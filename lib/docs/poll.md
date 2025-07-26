# Poll

## Topics, Options, Votes

### DDL

```plpgsql
-- topics
create table if not exists public.topics (
    id uuid primary key default gen_random_uuid(),
    created_by uuid not null default auth.uid() references auth.users(id) on delete cascade,
    title text not null,
    description text,
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null
);

-- options
create table if not exists public.options (
    id uuid primary key default gen_random_uuid(),
    topic_id uuid not null references public.topics(id) on delete cascade,
    content text not null, -- 선택지 내용
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null
);

-- votes
create table if not exists public.votes (
    id uuid primary key default gen_random_uuid(),
    option_id uuid not null references public.options(id) on delete cascade,
    created_by uuid not null default auth.uid() references auth.users(id) on delete cascade,
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null,
    unique (option_id, created_by)  -- 유저는 해당 옵션에 한 번만 투표 가능
);

-- set indexes
create index if not exists idx_topics_user_id on public.topics(created_by);
create index if not exists idx_options_topic_id on public.options(topic_id);
create index if not exists idx_votes_option_id on public.votes(option_id);
create index if not exists idx_votes_user_id on public.votes(created_by);

-- trigger on update_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_topics_updated_at
before update on public.topics
for each row
execute procedure public.set_updated_at();

create trigger set_options_updated_at
before update on public.options
for each row
execute procedure public.set_updated_at();

create trigger set_votes_updated_at
before update on public.votes
for each row
execute procedure public.set_updated_at();

-- RLS
alter table public.topics enable row level security;
create policy "view_topics" on public.topics for select using (auth.role() = 'authenticated');
create policy "insert_own_topics" on public.topics for insert with check (auth.uid() = created_by);
create policy "update_own_topics" on public.topics for update using (auth.uid() = created_by) with check (auth.uid() = created_by);
create policy "delete_own_topics" on public.topics for delete using (auth.uid() = created_by);

alter table public.options enable row level security;
create policy "view_options" on public.options for select using (auth.role() = 'authenticated');
create policy "insert_options_for_own_topic" on public.options for insert
  with check (auth.uid() = (select created_by from public.topics where id = topic_id));
create policy "update_own_options" on public.options for update
  using (auth.uid() = (select created_by from public.topics where id = topic_id))
  with check (auth.uid() = (select created_by from public.topics where id = topic_id));
create policy "delete_own_options" on public.options for delete
  using (auth.uid() = (select created_by from public.topics where id = topic_id));

alter table public.votes enable row level security;
create policy "view_votes" on public.votes for select using (auth.role() = 'authenticated');
create policy "insert_vote" on public.votes for insert with check (auth.uid() = created_by);
create policy "update_own_vote" on public.votes for update using (auth.uid() = created_by);
create policy "delete_own_vote" on public.votes for delete using (auth.uid() = created_by);
```

### RPC

- Create Topic

```
create or replace function public.create_topic_with_options(
  p_title text,
  p_description text,
  p_options text[]
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_topic_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Unauthenticated';
  end if;

  -- insert row on topics table
  insert into public.topics (created_by, title, description)
  values (auth.uid(), p_title, p_description)
  returning id into v_topic_id;

  -- insert rows on options table
  insert into public.options (topic_id, content)
  select v_topic_id, unnest(p_options);

  -- return topic id
  return v_topic_id;
end;
$$;

revoke all on function public.create_topic_with_options(text, text, text[]) from public;
grant execute on function public.create_topic_with_options(text, text, text[]) to authenticated;
```

- Get Topics With Options

```
-- define return type
drop type if exists public.topic_with_options_json cascade;
create type public.topic_with_options_json as (
  topic_id uuid,
  created_by uuid,
  title text,
  description text,
  created_at timestamptz,
  updated_at timestamptz,
  options jsonb
);

create or replace function public.get_topics_with_votes(
  p_limit int default 20,
  p_offset int default 0,
  p_search text default null
)
returns setof public.topic_with_options_json
language sql
security definer
set search_path = public
as $$
  with base as (
    select
      t.id as topic_id,
      t.created_by,
      t.title,
      t.description,
      t.created_at,
      t.updated_at
    from public.topics t
    where auth.role() = 'authenticated'
      and (p_search is null or t.title ilike '%' || p_search || '%' )
    order by t.created_at desc
    limit p_limit offset p_offset
  )
  select
    b.topic_id,
    b.created_by,
    b.title,
    b.description,
    b.created_at,
    b.updated_at,
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', o.id,
          'content', o.content,
          'vote_count', coalesce(vc.cnt, 0),
          'voted_by_me', exists (
            select 1 from public.votes v2
            where v2.option_id = o.id
              and v2.created_by = auth.uid()
          )
        )
        order by o.created_at
      )
      from public.options o
      left join lateral (
        select count(*)::bigint as cnt
        from public.votes v where v.option_id = o.id
      ) vc on true
      where o.topic_id = b.topic_id
    ) as options
  from base b;
$$;

revoke all on function public.get_topics_with_votes(int, int, text) from public;
grant execute on function public.get_topics_with_votes(int, int, text) to authenticated;
```