# posts

## Create Table

```
create table if not exists public.feed_posts (
    id            uuid primary key default gen_random_uuid(),
    author_id     uuid not null references public.users(id) on delete cascade default auth.uid(),
    content       text,
    likes_count   inteager not null default 0,
    is_public     boolean not null default true,
    created_at    timestamptz not null default now(),
    updated_at    timestamptz not null default now()
);

create index if not exists idx_feed_posts_created_at on public.feed_posts (created_at desc);
create index if not exists idx_feed_posts_author on public.feed_posts (author_id);

alter table public.feed_posts  enable row level security;

drop policy if exists "feed_posts_select_public" on public.feed_posts;
create policy "feed_posts_select_public"
on public.feed_posts 
for select to authenticated
using (is_public = true OR auth.uid() = author_id);

drop policy if exists "feed_posts_insert_own" on public.feed_posts;
create policy "feed_posts_insert_own"
on public.feed_posts for insert
with check (auth.uid() = author_id);

drop policy if exists "feed_posts_update_own" on public.feed_posts;
create policy "feed_posts_update_own"
on public.feed_posts for update
using (auth.uid() = author_id)
with check (auth.uid() = author_id);

drop policy if exists "feed_posts_delete_own" on public.feed_posts;
create policy "feed_posts_delete_own"
on public.feed_posts for delete
using (auth.uid() = author_id);
```
