create table if not exists public.feed_post_likes (
    post_id    uuid not null references public.feed_posts(id) on delete cascade,
    user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
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

-- rpc 함수 생성
create or replace function public.toggle_feed_like(_post_id uuid)
returns table(liked boolean, like_count integer)
language plpgsql
security definer
set search_path = public
as $$
declare
    _uid uuid := auth.uid();
    _liked_before boolean;
begin
    if _uid is null then
        raise exception 'toggle_feed_like: auth required (auth.uid() is null)';
    end if;
    
    -- 대상 포스트 잠금(동시성/경쟁 조건 방지)
    perform 1 from public.feed_posts where id = _post_id for update;
    if not found then
        raise exception 'toggle_feed_like: post % not found', _post_id;
    end if;
    
    select exists(
        select 1 from public.feed_post_likes
        where post_id = _post_id and user_id = _uid
    ) into _liked_before;
    
    if _liked_before then
        delete from public.feed_post_likes
        where post_id = _post_id and user_id = _uid;
    else
        insert into public.feed_post_likes (post_id, user_id)
        values (_post_id, _uid)
        on conflict (post_id, user_id) do nothing;
    end if;
    
    -- 정확성 우선: 재계산으로 like_count 반영
    update public.feed_posts p
    set like_count = sub.cnt
    from (
        select count(*)::int as cnt
        from public.feed_post_likes
        where post_id = _post_id
    ) sub
    where p.id = _post_id;
    
    liked := exists(
        select 1 from public.feed_post_likes
        where post_id = _post_id and user_id = _uid
    );
    select p.like_count into like_count
    from public.feed_posts p where p.id = _post_id;
    
    return next;
    end;
$$;

grant execute on function public.toggle_feed_like(uuid) to authenticated;
