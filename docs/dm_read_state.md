create table if not exists public.dm_room_read_state (
room_id uuid not null references public.dm_rooms(id) on delete cascade,
user_id uuid not null references auth.users(id) on delete cascade,
unread_count integer not null default 0;
last_read_message_id uuid references public.dm_messages(id) on delete set null,
last_read_at timestamptz not null default now(),
primary key (room_id, user_id)
);

create index if not exists idx_dm_read_user_room on public.dm_room_read_state (user_id, room_id);
create index if not exists idx_dm_read_room on public.dm_room_read_state (room_id);

alter table public.dm_room_read_state enable row level security;
alter table public.dm_room_read_state force row level security;

create policy "only participants can select"
on public.dm_room_read_state
for select
to authenticated
using (
exists (
select 1 from public.dm_rooms r
where r.id = room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create policy "permit insert own read state"
on public.dm_room_read_state
for insert
to authenticated
with check (
auth.uid() = user_id
and exists (
select 1 from public.dm_rooms r
where r.id = room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create policy "permit update own read state"
on public.dm_room_read_state
for update
to authenticated
using (
auth.uid() = user_id
and exists (
select 1 from public.dm_rooms r
where r.id = room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
)
with check (
auth.uid() = user_id
and exists (
select 1 from public.dm_rooms r
where r.id = room_id
and ((auth.uid() = r.user1_id) or (auth.uid() = r.user2_id))
)
);

create or replace function public.dm_unread_on_message_insert()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
_u1 uuid;
_u2 uuid;
_sender_id uuid;
_receiver_id uuid;
begin
-- sender_id, receiver_id 변수 초기화
select r.user1_id, r.user2_id into _u1, _u2
from public.dm_rooms r
where r.id = new.room_id;
_sender_id := new.sender_id;
if _sender_id = _u1 then
_receiver_id = _u2;
elsif _sender_id = _u2 then
_receiver_id = _u1;
end if;
if _sender_id == null or _receiver_id == null then
return new;
end if;
-- 메세지 보낸이 read state 업데이트
insert into public.dm_room_read_state as s
(room_id, user_id, last_read_message_id, last_read_at, unread_count)
values
(new.room_id, _sender_id, new.id, now(), 0)
on conflict (room_id, user_id) do update set
last_read_message_id = excluded.last_read_message_id,
last_read_at         = now(),
unread_count         = 0;
-- 메세지 받는이 read state 업데이트
insert into public.dm_room_read_state as s
(room_id, user_id, unread_count, last_read_message_id, last_read_at)
values
(new.room_id, _receiver_id, 1, null, now())
on conflict (room_id, user_id) do update set
unread_count = s.unread_count + 1;

return new;
end $$;

drop trigger if exists trg_dm_unread_on_message_insert on public.dm_messages;
create trigger trg_dm_unread_on_message_insert
after insert on public.dm_messages
for each row execute function public.dm_unread_on_message_insert();