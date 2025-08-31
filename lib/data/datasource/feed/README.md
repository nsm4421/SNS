# Feed Bucket

```
insert into storage.buckets (id, name, public)
values ('FEED_IMAGE', 'FEED_IMAGE', false)
on conflict (id) do update set public = false;

-- alter table storage.objects enable row level security;

create policy "permit read for authenticated"
on storage.objects
for select
to authenticated
using (bucket_id = 'FEED_IMAGE');

create policy "permit insert feed image to own folder"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'FEED_IMAGE'
  and name like concat(auth.uid()::text, '/%')
);

create policy "permit update own feed image"
on storage.objects
for update
to authenticated
using (bucket_id = 'FEED_IMAGE' and owner = auth.uid())
with check (bucket_id = 'FEED_IMAGE' and owner = auth.uid());

create policy "permit delete own feed image"
on storage.objects
for delete
to authenticated
using (bucket_id = 'FEED_IMAGE' and owner = auth.uid());
```