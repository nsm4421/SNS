# Images

## Create Table

```
create table if not exists public.feed_post_images (
  id            uuid primary key default gen_random_uuid(),
  post_id       uuid not null references public.feed_posts(id) on delete cascade,
  object_path   text not null,                       -- 예: "post_123/0.jpg"
  width         int,
  height        int,
  order_index   int not null default 0,              -- 정렬용
  created_at    timestamptz not null default now(),
  created_by     uuid not null references public.users(id) on delete cascade default auth.uid()
);

create unique index if not exists idx_feed_post_images_post_order on public.feed_post_images(post_id, order_index);
create index if not exists idx_feed_post_images_post on public.feed_post_images(post_id);

alter table public.feed_post_images enable row level security;

drop policy if exists "feed_post_images_select_public" on public.feed_post_images;
create policy "feed_post_images_select_public"
on public.feed_post_images 
for select to authenticated
using (true);

drop policy if exists "feed_post_images_insert" on public.feed_post_images;
create policy "feed_post_images_insert"
on public.feed_post_images for insert
with check ((auth.uid() = created_by) and (exists (
    select 1 from public.feed_posts p
    where p.id = feed_post_images.post_id and p.author_id = auth.uid()
)));
```