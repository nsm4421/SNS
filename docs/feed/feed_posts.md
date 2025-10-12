do $$ begin
create type public.feed_visibility as enum ('public', 'unlisted', 'private');
exception when duplicate_object then null; end $$;

create table if not exists public.feed_posts (
    id           uuid primary key default gen_random_uuid(),
    author_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
    content      text not null,
    visibility   public.feed_visibility not null default 'public',
    reply_to_id  uuid null references public.feed_posts(id) on delete set null, -- 쓰레드/답글용
    -- 좋아요, 댓글수
    like_count    bigint not null default 0,
    comment_count bigint not null default 0,
    -- 소프트 삭제를 하려면 deleted_at 사용
    deleted_at   timestamptz,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now(),
    -- 풀텍스트 검색을 위한 tsvector (한국어/영어 혼용 시 simple로 두고, 필요하면 unaccent 등 추가)
    content_tsv  tsvector generated always as (to_tsvector('simple', coalesce(content, ''))) stored
);

create index if not exists idx_feed_posts_created_at on public.feed_posts (created_at desc, id);
create index if not exists idx_feed_posts_author_created on public.feed_posts (author_id, created_at desc);
create index if not exists idx_feed_posts_content_tsv on public.feed_posts using gin (content_tsv);

create trigger trg_feed_posts_updated_at
before update on public.feed_posts
for each row execute function public.set_updated_at();

alter table public.feed_posts enable row level security;

create policy "can select only accessible feed posts"
on public.feed_posts
for select
to authenticated
using (
    (visibility = 'public' and deleted_at is null)
    or (author_id = auth.uid())
);

create policy "can insert only own feed post"
on public.feed_posts
for insert
to authenticated
with check (author_id = auth.uid());

create policy "can update only own feed post"
on public.feed_posts
for update
to authenticated
using (author_id = auth.uid())
with check (author_id = auth.uid());