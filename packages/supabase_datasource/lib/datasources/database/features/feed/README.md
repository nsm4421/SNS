## Extension

```
create extension if not exists "pgcrypto";   -- gen_random_uuid()
create extension if not exists "citext";     -- 대소문자 무시 unique
create extension if not exists "pg_trgm";    -- 해시태그/검색용 트라이그램
```


## Tables

### Feed

- feed posts

```
create table if not exists public.feed_posts (
    id            uuid primary key default gen_random_uuid(),
    author_id     uuid not null references public.users(id) on delete cascade default auth.uid(),
    content       text,
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

- feed post images

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

- feed post likes

```
create table if not exists public.feed_post_likes (
    post_id     uuid not null references public.feed_posts(id) on delete cascade,
    user_id     uuid not null references public.users(id) on delete cascade default auth.uid(),
    created_at  timestamptz not null default now(),
    primary key (post_id, user_id)  -- 한 유저가 한 번만 좋아요
);

create index if not exists idx_feed_post_likes_post on public.feed_post_likes(post_id);
create index if not exists idx_feed_post_likes_user on public.feed_post_likes(user_id);

alter table public.feed_post_likes enable row level security;

drop policy if exists "feed_post_likes_select_authenticated" on public.feed_post_likes;
create policy "feed_post_likes_select_authenticated"
on public.feed_post_likes for select to authenticated
using (true);

drop policy if exists "feed_post_likes_insert_own" on public.feed_post_likes;
create policy "feed_post_likes_insert_own"
on public.feed_post_likes for insert
with check (auth.uid() = user_id);

drop policy if exists "feed_post_likes_delete_own" on public.feed_post_likes;
create policy "feed_post_likes_delete_own"
on public.feed_post_likes for delete
using (auth.uid() = user_id);
```

- feed post comments

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

- Trigger
```
drop trigger if exists set_feed_post_updated_at on public.feed_posts;
create trigger set_feed_post_updated_at
before update on public.feed_posts
for each row
execute function public.set_updated_at(); -- 미리 만들어둔 set_updated_at함수
```

- View
  - feed_with_images_and_counts 

```
create or replace view public.feed_with_images_and_counts as
select
    p.*,
    coalesce(l.like_count, 0)     as likes_count,
    coalesce(c.comment_count, 0)  as comments_count,
    username                      as username,
    coalesce(imgs.images, '{}'::text[]) as images   -- 이미지 배열(JSONB)
from public.feed_posts p
left join (
    -- 좋아요 개수
    select post_id, count(*)::int as like_count
    from public.feed_post_likes
    group by post_id
) l on l.post_id = p.id
left join (
    -- 댓글 개수
    select post_id, count(*)::int as comment_count
    from public.feed_post_comments
    where deleted_at is null    -- 삭제된 댓글 제외
        and parent_id is null   -- 부모댓글만 카운팅
    group by post_id
) c on c.post_id = p.id
left join (
    -- 작성자
    select id, username
    from public.users
) u on u.id = p.author_id
left join lateral (
    select array_agg(fpi.object_path order by fpi.order_index, fpi.created_at) as images
    from public.feed_post_images fpi
    where fpi.post_id = p.id
) imgs on true;
```

- RPC Function
  - toggle_post_like

```
create or replace function public.toggle_post_like(p_post_id uuid)
returns void
language plpgsql
security definer
as $$
declare
    v_user uuid := auth.uid();
begin
    if v_user is null then
        raise exception 'not authenticated';
    end if;
    
    -- 이미 좋아요면 취소, 아니면 추가
    if exists (select 1 from public.feed_post_likes where post_id = p_post_id and user_id = v_user) then
        delete from public.feed_post_likes where post_id = p_post_id and user_id = v_user;
    else
        insert into public.feed_post_likes(post_id, user_id) values (p_post_id, v_user)
        on conflict do nothing;
    end if;
end;
$$;

revoke all on function public.toggle_post_like(uuid) from public;
grant execute on function public.toggle_post_like(uuid) to anon, authenticated;
```
