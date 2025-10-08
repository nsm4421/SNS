create table public.dm_rooms (
id uuid primary key default gen_random_uuid(),
user1_id uuid not null references auth.users(id) on delete cascade,
user2_id uuid not null references auth.users(id) on delete cascade,
last_message_at timestamptz,
created_at timestamptz not null default now(),
updated_at timestamptz not null default now(),
check (user1_id < user2_id)
);

create unique index uq_dm_pair on public.dm_rooms (user1_id, user2_id);

create trigger on_dm_rooms_updated_at
before update on public.dm_rooms
for each row execute function public.set_updated_at();

alter table public.dm_rooms enable row level security;

create policy "only dm rooms participants can select"
on public.dm_rooms
for select
to authenticated
using (
auth.uid() = user1_id or auth.uid() = user2_id
);

create policy "permit insert self only"
on public.dm_rooms
for insert
to authenticated
with check (
auth.uid() is not null
and (auth.uid() = user1_id or auth.uid() = user2_id)
);

create policy "only participants can update"
on public.dm_rooms
for update
to authenticated
using (
auth.uid() = user1_id or auth.uid() = user2_id
)
with check (
auth.uid() = user1_id or auth.uid() = user2_id
);

create policy "only dm rooms participants can delete"
on public.dm_rooms
for delete
to authenticated
using (
auth.uid() = user1_id or auth.uid() = user2_id
);
