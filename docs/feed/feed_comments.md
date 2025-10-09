create table if not exists public.feed_comments (
    id           uuid primary key default gen_random_uuid(),
    post_id      uuid not null references public.feed_posts(id) on delete cascade,
    author_id    uuid not null references auth.users(id) on delete cascade,
    parent_id    uuid null references public.feed_comments(id) on delete cascade, -- 대댓글
    content      text not null,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now(),
    deleted_at   timestamptz null
);

create index if not exists idx_feed_comments_post_created
on public.feed_comments (post_id, created_at asc);
create index if not exists idx_feed_comments_parent
on public.feed_comments (parent_id);

create trigger trg_feed_comments_updated_at
before update on public.feed_comments
for each row execute function public.set_updated_at();

alter table public.feed_comments enable row level security;

create policy "접근 가능한 게시글의 댓글만 조회 가능"
on public.feed_comments
for select
to authenticated
using (
    exists (
        select 1 from public.feed_posts p
        where p.id = post_id and (
            (p.visibility = 'public' and p.deleted_at is null)
            or (p.author_id = auth.uid())
        )
    )
);

create policy "접근 가능한 게시글에 작성자가 자신인 댓글만 insert 가능"
on public.feed_comments
for insert
to authenticated
with check (
    auth.uid() is not null
    and author_id = auth.uid()
    and exists (
        select 1 from public.feed_posts p
        where p.id = post_id and (
            (p.visibility = 'public' and p.deleted_at is null)
            or (p.author_id = auth.uid())
        )
    )
);

create policy "접근 가능한 게시글에 작성자가 자신인 댓글만 update 가능"
on public.feed_comments
for update
to authenticated
using (author_id = auth.uid())
with check (author_id = auth.uid());

create policy "자기 댓글만 삭제 가능"
on public.feed_comments
for delete
to authenticated
using (author_id = auth.uid());

create or replace function public.trg_feed_posts_comment_count()
returns trigger language plpgsql as $$
begin
    if tg_op = 'INSERT' then
        -- 새 댓글이 살아있는 상태로 들어오면 +1
        if new.deleted_at is null then
            update public.feed_posts
            set comment_count = comment_count + 1
            where id = new.post_id;
        end if;
        return new;

    elsif tg_op = 'DELETE' then
        -- 삭제되는 댓글이 살아있던 댓글이면 -1
        if old.deleted_at is null then
            update public.feed_posts
            set comment_count = greatest(comment_count - 1, 0)
            where id = old.post_id;
        end if;
        return old;

    elsif tg_op = 'UPDATE' then
        -- 소프트 삭제/복구 전환 감지
        if old.deleted_at is null and new.deleted_at is not null then
            update public.feed_posts
            set comment_count = greatest(comment_count - 1, 0)
            where id = new.post_id;
        elsif old.deleted_at is not null and new.deleted_at is null then
            update public.feed_posts
            set comment_count = comment_count + 1
            where id = new.post_id;
        end if;
        return new;
    end if;

    return null;
end $$;

drop trigger if exists feed_comments_count_aiud on public.feed_comments;

create trigger feed_comments_count_aiud
after insert or update or delete on public.feed_comments
for each row execute function public.trg_feed_posts_comment_count();

