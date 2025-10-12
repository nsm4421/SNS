create table if not exists public.feed_media (
    id           uuid primary key default gen_random_uuid(),
    post_id      uuid not null references public.feed_posts(id) on delete cascade,
    storage_path text not null,
    mime_type    text,
    width        int,
    height       int,
    sort_order   int not null default 0,
    created_at   timestamptz not null default now()
);

create index if not exists idx_feed_media_post_order
on public.feed_media (post_id, sort_order);

alter table public.feed_media enable row level security;

create policy "can select only accessible feed media"
on public.feed_media
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

create policy "can insert only accessible feed media"
on public.feed_media
for insert
to authenticated
    with check (
        exists (
            select 1
            from public.feed_posts p
            where p.id = post_id and p.author_id = auth.uid()
    )
);

create policy "can update only accessible feed media"
on public.feed_media
for update
to authenticated
using (
    exists (
        select 1 
        from public.feed_posts p
        where p.id = post_id and p.author_id = auth.uid()
    )
)
with check (
    exists (
        select 1 
        from public.feed_posts p
        where p.id = post_id and p.author_id = auth.uid()
    )
);

-- Bucket
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('feeds', 'feeds', true, 52428800, array['image/*','video/*']);

create policy "feeds read public"
on storage.objects for select
using ( bucket_id = 'feeds' );

create policy "feeds insert by authenticated"
on storage.objects for insert
with check (
    bucket_id = 'feeds'
    and auth.role() = 'authenticated'
);

create policy "feeds delete by owner"
on storage.objects for delete
using (
    bucket_id = 'feeds'
    and owner = auth.uid()
);

create policy "feeds update by owner"
on storage.objects for update
using (
    bucket_id = 'feeds'
    and owner = auth.uid()
);
