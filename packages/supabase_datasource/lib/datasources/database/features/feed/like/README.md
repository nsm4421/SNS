# Likes

## Create Table

```
create table if not exists public.feed_post_likes (
    post_id     uuid not null references public.feed_posts(id) on delete cascade,
    created_by     uuid not null references public.users(id) on delete cascade default auth.uid(),
    created_at  timestamptz not null default now(),
    primary key (post_id, created_by)  -- 한 유저가 한 번만 좋아요
);

create index if not exists idx_feed_post_likes_post on public.feed_post_likes(post_id);
create index if not exists idx_feed_post_likes_user on public.feed_post_likes(created_by);

alter table public.feed_post_likes enable row level security;

drop policy if exists feed_post_likes_select_own on public.feed_post_likes;
create policy feed_post_likes_select_own
on public.feed_post_likes
for select to authenticated
using (created_by = auth.uid());

drop policy if exists "feed_post_likes_insert_own" on public.feed_post_likes;
create policy "feed_post_likes_insert_own"
on public.feed_post_likes for insert
with check (auth.uid() = created_by);

drop policy if exists "feed_post_likes_delete_own" on public.feed_post_likes;
create policy "feed_post_likes_delete_own"
on public.feed_post_likes for delete
using (auth.uid() = created_by);
```

## Trigger

```
create or replace function public._increase_post_likes_count()
returns trigger language plpgsql as $$
begin
  update public.feed_posts
     set likes_count = likes_count + 1
   where id = new.post_id;
  return new;
end; $$;

create or replace function public._decrease_post_likes_count()
returns trigger language plpgsql as $$
begin
  update public.feed_posts
     set likes_count = greatest(likes_count - 1, 0)
   where id = old.post_id;
  return old;
end; $$;

drop trigger if exists trigger_on_increase_likes_count_of_feed_post on public.feed_post_likes;
create trigger trigger_on_increase_likes_count_of_feed_post after insert on public.feed_post_likes
for each row execute function public._increase_post_likes_count();

drop trigger if exists trigger_on_decrease_likes_count_of_feed_post on public.feed_post_likes;
create trigger trigger_on_decrease_likes_count_of_feed_post after delete on public.feed_post_likes
for each row execute function public._decrease_post_likes_count();
```

## RPC Function

### toggle_post_like

```
create or replace function public.toggle_post_like(p_post_id uuid)
returns integer
language plpgsql
security definer
as $$
declare
    v_user uuid := auth.uid();
    v_like_count integer;
begin
    if v_user is null then
        raise exception 'not authenticated';
    end if;
    
    -- 이미 좋아요면 취소, 아니면 추가
    if exists (select 1 from public.feed_post_likes where post_id = p_post_id and created_by = v_user) then
        delete from public.feed_post_likes where post_id = p_post_id and created_by = v_user;
    else
        insert into public.feed_post_likes(post_id, created_by) values (p_post_id, v_user)
        on conflict do nothing;
    end if;
    
    select likes_count
    into v_like_count
    from public.feed_with_images_and_counts
    where id = p_post_id;

    return v_like_count;
end;
$$;

revoke all on function public.toggle_post_like(uuid) from public;
grant execute on function public.toggle_post_like(uuid) to anon, authenticated;
```