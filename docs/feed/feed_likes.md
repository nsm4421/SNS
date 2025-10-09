create table if not exists public.feed_post_likes (
    post_id    uuid not null references public.feed_posts(id) on delete cascade,
    user_id    uuid not null references auth.users(id) on delete cascade,
    created_at timestamptz not null default now(),
    primary key (post_id, user_id)     -- 중복 좋아요 방지
);

create index if not exists idx_feed_likes_user_created
on public.feed_post_likes (user_id, created_at desc);

alter table public.feed_post_likes enable row level security;

create policy "can select only accessible feed like"
on public.feed_post_likes
for select
to authenticated
using (
    exists (
        select 1 from public.feed_posts p
        where p.id = post_id
            and (
            (p.visibility = 'public' and p.deleted_at is null)
            or (p.author_id = auth.uid())
        )
    )
);

create policy "can insert only accessible feed like"
on public.feed_post_likes
for insert
to authenticated
with check (
    auth.uid() is not null
        and exists (
            select 1 from public.feed_posts p
            where p.id = post_id and (
                (p.visibility = 'public' and p.deleted_at is null)
                or (p.author_id = auth.uid()
            )
        )
    )
);

create policy "can delete own data"
on public.feed_post_likes
for delete
to authenticated
using (user_id = auth.uid());

create or replace function public.trg_feed_posts_like_count()
returns trigger language plpgsql as $$ 
begin
    if tg_op = 'INSERT' then
        update public.feed_posts
        set like_count = like_count + 1
        where id = new.post_id;
        return new;
    elsif tg_op = 'DELETE' then
        update public.feed_posts
        set like_count = greatest(like_count - 1, 0)
        where id = old.post_id;
        return old;
    end if;
        return null;
    end 
$$;

drop trigger if exists feed_post_likes_count_aiud on public.feed_post_likes;

create trigger feed_post_likes_count_aiud
after insert or delete on public.feed_post_likes
for each row execute function public.trg_feed_posts_like_count();

