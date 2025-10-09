create or replace view public.v_feed_list as
select
    p.id,
    p.author_id,
    p.content,
    p.visibility,
    p.reply_to_id,
    p.deleted_at,
    p.created_at,
    p.updated_at,
    p.like_count,
    p.comment_count,
    
    -- 작성자 프로필
    pr.username        as author_username,
    pr.avatar_url      as author_avatar_url,
    
    -- 최신 댓글(없으면 null)
    lc.id              as latest_comment_id,
    lc.content         as latest_comment_content,
    lc.author_id       as latest_comment_author_id,
    lcp.username       as latest_comment_author_username,
    lcp.avatar_url     as latest_comment_author_avatar_url,
    lc.created_at      as latest_comment_created_at
    
from public.feed_posts p
    -- 피드 작성자
    join public.profiles pr on pr.user_id = p.author_id
    -- 최근 댓글
    left join lateral (
        select c.*
        from public.feed_comments c
        where c.post_id = p.id
            and c.deleted_at is null
        order by c.created_at desc, c.id desc
        limit 1
    ) lc on true
    -- 최근 댓글 작성자
    left join public.profiles lcp on lcp.user_id = lc.author_id;
