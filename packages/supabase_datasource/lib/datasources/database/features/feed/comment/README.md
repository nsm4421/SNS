# Comments

## Create Table

```
create table if not exists public.feed_post_comments (
    id             uuid primary key default gen_random_uuid(),
    post_id        uuid not null references public.feed_posts(id) on delete cascade,
    created_by        uuid not null references public.users(id) on delete cascade default auth.uid(),
    parent_id      uuid references public.feed_post_comments(id) on delete cascade,
    content        text not null,
    created_at     timestamptz not null default now(),
    updated_at     timestamptz,
    deleted_at     timestamptz
);

create index if not exists idx_feed_post_comments_post on public.feed_post_comments(post_id);
create index if not exists idx_feed_post_comments_parent on public.feed_post_comments(parent_id);
create index if not exists idx_feed_post_comments_user on public.feed_post_comments(created_by);

alter table public.feed_post_comments  enable row level security;

drop policy if exists "feed_post_comments_select_public" on public.feed_post_comments;
create policy "feed_post_comments_select_public"
on public.feed_post_comments for select
using (true);

drop policy if exists "feed_post_comments_insert_own" on public.feed_post_comments;
create policy "feed_post_comments_insert_own"
on public.feed_post_comments for insert
with check (auth.uid() = created_by);

drop policy if exists "feed_post_comments_update_own" on public.feed_post_comments;
create policy "feed_post_comments_update_own"
on public.feed_post_comments for update
using (auth.uid() = created_by)
with check (auth.uid() = created_by);

drop policy if exists "feed_post_comments_delete_own_or_post_author" on public.feed_post_comments;
create policy "feed_post_comments_delete_own_or_post_author"
on public.feed_post_comments for delete
using (
  auth.uid() = created_by OR
  exists (select 1 from public.feed_posts p
          where p.id = feed_post_comments.post_id
            and p.author_id = auth.uid())
);
```

## Trigger

```
create or replace function public._increase_post_comments_count()
returns trigger language plpgsql as $$
begin
  update public.feed_posts
     set comments_count = comments_count + 1
   where id = new.post_id;
  return new;
end; $$;

create or replace function public._decrease_post_comments_count()
returns trigger language plpgsql as $$
begin
  update public.feed_posts
     set comments_count = greatest(comments_count - 1, 0)
   where id = old.post_id;
  return old;
end; $$;

drop trigger if exists trigger_on_increase_comments_count_of_feed_post on public.feed_post_comments;
create trigger trigger_on_increase_comments_count_of_feed_post after insert on public.feed_post_comments
for each row execute function public._increase_post_comments_count();

drop trigger if exists trigger_on_decrease_comments_count_of_feed_post on public.feed_post_comments;
create trigger trigger_on_decrease_comments_count_of_feed_post after delete on public.feed_post_comments
for each row execute function public._decrease_post_comments_count();
```

## View
```
create or replace view public.feed_post_comments_with_author as
select
  c.id,
  c.post_id,
  c.parent_id,
  c.content,
  c.created_at,
  u.id          as created_by,
  u.username    as username
from public.feed_post_comments c left join public.users u on u.id = c.created_by;
```