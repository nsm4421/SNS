## Extension

```
create extension if not exists "pgcrypto";   -- gen_random_uuid()
create extension if not exists "citext";     -- 대소문자 무시 unique
create extension if not exists "pg_trgm";    -- 해시태그/검색용 트라이그램
```

## UpdateAt 필드 처리

```
drop trigger if exists set_feed_post_updated_at on public.feed_posts;
create trigger set_feed_post_updated_at
before update on public.feed_posts
for each row
execute function public.set_updated_at(); -- 미리 만들어둔 set_updated_at함수
```

## View
  - feed_with_images_and_counts 

```
create or replace view public.feed_with_images_and_counts as
select
    p.*,
    u.username,
    coalesce(i.images, '{}'::text[]) as images,   -- 이미지 배열(JSONB)
    (l.created_by is not null) as liked_by_me
from public.feed_posts p
left join (
    -- 작성자
    select id, username
    from public.users
) u on u.id = p.created_by
left join (
    -- 댓글 개수
    select post_id, count(*)::int as comment_count
    from public.feed_post_comments
    where deleted_at is null    -- 삭제된 댓글 제외
        and parent_id is null   -- 부모댓글만 카운팅
    group by post_id
) c on c.post_id = p.id
left join lateral (
    -- 이미지 경로
    select array_agg(fpi.object_path order by fpi.order_index, fpi.created_at) as images
    from public.feed_post_images fpi
    where fpi.post_id = p.id
) i on true
left join public.feed_post_likes l
  -- 좋아요 여부
  on l.post_id = p.id
 and l.created_by = auth.uid();
```