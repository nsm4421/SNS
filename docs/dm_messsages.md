create table public.dm_messages (
id uuid primary key default gen_random_uuid(),
room_id uuid not null references public.dm_rooms(id) on delete cascade,
sender_id uuid not null references auth.users(id) on delete cascade,
content text,                                -- text/system/custom payload
msg_type public.message_type not null default 'text',
metadata jsonb,                              -- 멘션, 하이라이트, 확장필드 등
created_at timestamptz not null default now(),
updated_at timestamptz not null default now(),
deleted_at timestamptz                       -- 소프트 삭제
);

create index if not exists idx_dm_messages_room_created_desc
on public.dm_messages (room_id, created_at desc, id desc);

create index if not exists idx_dm_messages_sender_created_desc
on public.dm_messages (sender_id, created_at desc);

create trigger on_dm_messages_updated_at
before update on public.dm_messages
for each row execute function public.set_updated_at();

create or replace function public.bump_dm_last_message_at()
returns trigger language plpgsql as $$
begin
update public.dm_rooms
set last_message_at = new.created_at
where id = new.room_id
and (last_message_at is null or new.created_at > last_message_at);
return new;
end $$;

create trigger trg_bump_dm_last_message_at
after insert on public.dm_messages
for each row execute function public.bump_dm_last_message_at();

alter table public.dm_messages enable row level security;

create policy "only participants can select"
on public.dm_messages
for select
to authenticated
using (
exists (
select 1
from public.dm_rooms r
where r.id = dm_messages.room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create policy "only insert own message"
on public.dm_messages
for insert
to authenticated
with check (
auth.uid() is not null
and sender_id = auth.uid()
and exists (
select 1
from public.dm_rooms r
where r.id = dm_messages.room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create policy "permit soft delete only author"
on public.dm_messages
for update
to authenticated
using (
sender_id = auth.uid()
and exists (
select 1
from public.dm_rooms r
where r.id = dm_messages.room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
)
with check (
sender_id = auth.uid()
and exists (
select 1
from public.dm_rooms r
where r.id = dm_messages.room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create policy "permit hard delete only author"
on public.dm_messages
for delete
to authenticated
using (
sender_id = auth.uid()
and exists (
select 1
from public.dm_rooms r
where r.id = dm_messages.room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);