# 결정장애를 위한 앱 만들기

## 기술스택

### Flutter + Supabase

## Features

### Auth

```plpgsql
-- public.users테이블 생성
create table if not exists public.users (
    id uuid primary key references auth.users(id) on delete cascade
    , username text unique not null
    , created_at timestamp with time zone default timezone('utc'::text, now()) not null
    , updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 회원가입 시(auth.users테이블에 insert시) public.users 테이블에 insert하도록 설정
create or replace function public.handle_insert_on_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, username)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'username'
    )
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_inserted
after insert on auth.users
for each row
execute procedure public.handle_insert_on_auth_user();

-- username이 변경될 때(auth.users테이블의 raw_user_meta_data필드가 업데이트 될 때), public.users 테이블도 업데이트
create or replace function public.handle_updated_on_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.users
  set username = coalesce(new.raw_user_meta_data->>'username', username)
  where id = new.id;

  return new;
end;
$$;

create trigger on_auth_user_updated
after update of raw_user_meta_data on auth.users
for each row
execute procedure public.handle_updated_on_auth_user();

-- public.users테이블 update시, updated_at필드에 update
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

create trigger set_users_updated_at
before update on public.users
for each row
execute procedure public.set_updated_at();

-- RLS설정
alter table public.users enable row level security;

create policy "Users are viewable by authenticated users"
on public.users
for select
using (auth.role() = 'authenticated');

create policy "Users can insert their own row"
on public.users
for insert
with check (auth.uid() = id);

create policy "Users can update their own row"
on public.users
for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can delete their own row"
on public.users
for delete
using (auth.uid() = id);
```

### Poll

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
    seq integer not null default 0,
    content text not null, -- 선택지 내용
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null,
    unique(topic_id, seq)
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
create policy "permit select for authenticated" on public.topics for select using (auth.role() = 'authenticated');
create policy "can insert own data" on public.topics for insert with check (auth.uid() = created_by);
create policy "can update own data" on public.topics for update using (auth.uid() = created_by) with check (auth.uid() = created_by);
create policy "can delete own data" on public.topics for delete using (auth.uid() = created_by);

alter table public.options enable row level security;
create policy "permit select for authenticated" on public.options for select using (auth.role() = 'authenticated');
create policy "only author can insert" on public.options for insert
  with check (auth.uid() = (select created_by from public.topics where id = topic_id));
create policy "only author can update" on public.options for update
  using (auth.uid() = (select created_by from public.topics where id = topic_id))
  with check (auth.uid() = (select created_by from public.topics where id = topic_id));
create policy "only author can delete" on public.options for delete
  using (auth.uid() = (select created_by from public.topics where id = topic_id));

alter table public.votes enable row level security;
create policy "permit select for authenticated" on public.votes for select using (auth.role() = 'authenticated');
create policy "can insert own data" on public.votes for insert with check (auth.uid() = created_by);
create policy "can update own data" on public.votes for update using (auth.uid() = created_by);
create policy "can delete own data" on public.votes for delete using (auth.uid() = created_by);

--- RPC

-- create topic with options
create or replace function public.create_topic_with_options(
  p_title       text,
  p_description text,
  p_options     text[]
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_topic_id uuid;
begin
  -- 인증여부 체크
  if auth.uid() is null then
    raise exception 'Unauthenticated';
  end if;

  -- topics 테이블에 insert
  insert into public.topics (created_by, title, description)
  values (auth.uid(), p_title, p_description)
  returning id into v_topic_id;

  --  options 테이블에 insert (with ordinality 로 seq 부여)
  insert into public.options (topic_id, content, seq)
  select
    v_topic_id,
    opt,
    ord
  from unnest(p_options) with ordinality as t(opt, ord);

  return v_topic_id;
end;
$$;

-- 권한 설정
revoke all on function public.create_topic_with_options(text, text, text[]) from public;
grant execute on function public.create_topic_with_options(text, text, text[]) to authenticated;

-- get_topic_detail
-- topics, options, votes테이블 join한 결과 가져오기
drop type if exists public.topic_detail cascade;
create type public.topic_detail as (
  topic_id    uuid,
  created_by  uuid,
  title       text,
  description text,
  created_at  timestamptz,
  updated_at  timestamptz,
  options     jsonb
);

-- 1) 반환 타입 재정의 (options JSON 내 필드 확장)
drop type if exists public.topic_with_options_json cascade;
create type public.topic_with_options_json as (
  topic_id    uuid,
  created_by  uuid,
  title       text,
  description text,
  created_at  timestamptz,
  updated_at  timestamptz,
  options     jsonb
);

-- 2) topic 단건 + 옵션 조회 RPC
create or replace function public.get_topic_detail(
  p_topic_id uuid
)
returns setof public.topic_detail
language sql
security definer
set search_path = public
as $$
  with me as (
    select auth.uid() as uid
  ), base as (
    select
      t.id         as topic_id,
      t.created_by,
      t.title,
      t.description,
      t.created_at,
      t.updated_at
    from public.topics t
    where t.id = p_topic_id
      and auth.role() = 'authenticated'
  )
  select
    b.topic_id,
    b.created_by,
    b.title,
    b.description,
    b.created_at,
    b.updated_at,
    coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'id',           o.id,
            'content',      o.content,
            'seq',          o.seq,
            'vote_count',   coalesce(vc.cnt, 0),
            'voted_by_me',  exists (
              select 1
              from public.votes v2
              cross join me
              where v2.option_id   = o.id
                and v2.created_by  = me.uid
            )
          ) order by o.seq
        )
        from public.options o
        left join lateral (
          select count(*)::int as cnt
          from public.votes v
          where v.option_id = o.id
        ) vc on true
        where o.topic_id = b.topic_id
      )
    , '[]'::jsonb
    ) as options
  from base b;
$$;

-- 권한 재설정
revoke all on function public.get_topic_detail(uuid) from public;
grant execute on function public.get_topic_detail(uuid) to authenticated;
```

### Comment

```plpgsql
-- topic 댓글
create table if not exists public.topic_comments (
    id uuid primary key default gen_random_uuid(),
    topic_id uuid not null,
    created_by uuid not null default auth.uid() references auth.users(id) on delete cascade,
    content text not null,
    created_at timestamptz default now() not null,
    updated_at timestamptz default now() not null
);

alter table public.topic_comments enable row level security;
create policy "permit select for authenticated" on public.topic_comments for select using (auth.role() = 'authenticated');
create policy "can insert own data" on public.topic_comments for insert with check (auth.uid() = created_by);
create policy "can update own data" on public.topic_comments for update using (auth.uid() = created_by) with check (auth.uid() = created_by);
create policy "can delete own data" on public.topic_comments for delete using (auth.uid() = created_by);
```