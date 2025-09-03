# Comments

## Create Table

```
create table if not exists public.feed_post_comments (
    id             uuid primary key default gen_random_uuid(),
    post_id        uuid not null references public.feed_posts(id) on delete cascade,
    user_id        uuid not null references public.users(id) on delete cascade default auth.uid(),
    parent_id      uuid references public.feed_post_comments(id) on delete cascade,
    content        text not null,
    created_at     timestamptz not null default now(),
    updated_at     timestamptz,
    deleted_at     timestamptz
);

create index if not exists idx_feed_post_comments_post on public.feed_post_comments(post_id);
create index if not exists idx_feed_post_comments_parent on public.feed_post_comments(parent_id);
create index if not exists idx_feed_post_comments_user on public.feed_post_comments(user_id);

alter table public.feed_post_comments  enable row level security;

drop policy if exists "feed_post_comments_select_public" on public.feed_post_comments;
create policy "feed_post_comments_select_public"
on public.feed_post_comments for select
using (true);

drop policy if exists "feed_post_comments_insert_own" on public.feed_post_comments;
create policy "feed_post_comments_insert_own"
on public.feed_post_comments for insert
with check (auth.uid() = user_id);

drop policy if exists "feed_post_comments_update_own" on public.feed_post_comments;
create policy "feed_post_comments_update_own"
on public.feed_post_comments for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "feed_post_comments_delete_own_or_post_author" on public.feed_post_comments;
create policy "feed_post_comments_delete_own_or_post_author"
on public.feed_post_comments for delete
using (
  auth.uid() = user_id OR
  exists (select 1 from public.feed_posts p
          where p.id = feed_post_comments.post_id
            and p.author_id = auth.uid())
);
```
