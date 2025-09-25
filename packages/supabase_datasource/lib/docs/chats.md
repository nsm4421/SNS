-- 메시지 입력 시 방의 last_message_at 갱신 함수
create or replace function public.bump_room_last_message_at()
returns trigger language plpgsql as $$
begin
update public.chat_rooms
set last_message_at = new.created_at,
updated_at      = now()
where id = new.room_id;
return new;
end $$;

-- ========== 1) 채팅방 ==========
create table if not exists public.chat_rooms (
id               uuid primary key default gen_random_uuid(),
is_group         boolean not null default false,
name             text,                           -- 그룹명(1:1은 null 가능)
owner_id         uuid references auth.users(id) on delete set null,
last_message_at  timestamptz,
created_at       timestamptz not null default now(),
updated_at       timestamptz not null default now()
);

create index if not exists idx_chat_rooms_last_message_at
on public.chat_rooms (last_message_at desc);

create trigger chat_rooms_set_updated_at
before update on public.chat_rooms
for each row execute function public.set_updated_at();

-- ========== 2) 방 멤버십 ==========
create table if not exists public.chat_room_members (
room_id                 uuid not null references public.chat_rooms(id) on delete cascade,
user_id                 uuid not null references auth.users(id) on delete cascade,
role                    text not null default 'member',  -- owner/admin/member
joined_at               timestamptz not null default now(),
last_read_at            timestamptz,
last_read_message_id    uuid,                            -- 선언 뒤에 FK 부여
is_muted                boolean not null default false,
primary key (room_id, user_id)
);

create index if not exists idx_chat_room_members_user
on public.chat_room_members (user_id);

-- ========== 3) 메시지 ==========
create table if not exists public.chat_messages (
id               uuid primary key default gen_random_uuid(),
room_id          uuid not null references public.chat_rooms(id) on delete cascade,
sender_id        uuid not null references auth.users(id) on delete cascade,
content          text,                                  -- 텍스트 본문
msg_type         text not null default 'text',          -- 'text' | 'image' | 'file' ...
metadata         jsonb not null default '{}'::jsonb,    -- 첨부/미디어 메타
created_at       timestamptz not null default now(),
edited_at        timestamptz,
deleted_at       timestamptz
);

create index if not exists idx_chat_messages_room_created
on public.chat_messages (room_id, created_at desc);

create index if not exists idx_chat_messages_sender_created
on public.chat_messages (sender_id, created_at desc);

-- 방 last_message_at 갱신 트리거
create trigger chat_messages_bump_room
after insert on public.chat_messages
for each row execute function public.bump_room_last_message_at();

-- 방 멤버 테이블의 last_read_message_id FK(지연 선언)
alter table public.chat_room_members
add constraint chat_room_members_last_read_fk
foreign key (last_read_message_id) references public.chat_messages(id) on delete set null;

-- ========== 4) 메시지 읽음(선택: 정밀 읽음표시) ==========
create table if not exists public.chat_message_reads (
message_id       uuid not null references public.chat_messages(id) on delete cascade,
user_id          uuid not null references auth.users(id) on delete cascade,
read_at          timestamptz not null default now(),
primary key (message_id, user_id)
);

create index if not exists idx_chat_message_reads_message
on public.chat_message_reads (message_id);

-- ========== 5) RLS 활성화 ==========
alter table public.chat_rooms          enable row level security;
alter table public.chat_room_members   enable row level security;
alter table public.chat_messages       enable row level security;
alter table public.chat_message_reads  enable row level security;

-- 공통 조건: 현재 사용자(auth.uid())가 방의 멤버인가?
-- (정식 함수 없이 정책 내 exists 서브쿼리로 간단히 구현)

-- ---- chat_rooms ----
drop policy if exists "read rooms I belong to" on public.chat_rooms;
create policy "read rooms I belong to"
on public.chat_rooms
for select
using (
exists (
select 1 from public.chat_room_members m
where m.room_id = chat_rooms.id
and m.user_id = auth.uid()
)
);

-- 방 생성은 소유자 관점에서 허용(필요 시 더 제한 가능)
drop policy if exists "create room (owner=self)" on public.chat_rooms;
create policy "create room (owner=self)"
on public.chat_rooms
for insert
with check (owner_id = auth.uid());

-- 방 메타 업데이트: 소유자/관리자만 (간단 버전: 소유자만)
drop policy if exists "update room by owner" on public.chat_rooms;
create policy "update room by owner"
on public.chat_rooms
for update
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

-- ---- chat_room_members ----
drop policy if exists "read memberships of my rooms" on public.chat_room_members;
create policy "read memberships of my rooms"
on public.chat_room_members
for select
using (
exists (
select 1 from public.chat_room_members me
where me.room_id = chat_room_members.room_id
and me.user_id = auth.uid()
)
);

-- 멤버 추가: owner/admin만
drop policy if exists "add member by admin" on public.chat_room_members;
create policy "add member by admin"
on public.chat_room_members
for insert
with check (
exists (
select 1 from public.chat_room_members am
where am.room_id = chat_room_members.room_id
and am.user_id = auth.uid()
and am.role in ('owner','admin')
)
);

-- 내 멤버십 내 정보 수정(읽음/뮤트 등): 본인만
drop policy if exists "update my membership" on public.chat_room_members;
create policy "update my membership"
on public.chat_room_members
for update
using (user_id = auth.uid())
with check (user_id = auth.uid());

-- 멤버 제거: owner/admin만
drop policy if exists "remove member by admin" on public.chat_room_members;
create policy "remove member by admin"
on public.chat_room_members
for delete
using (
exists (
select 1 from public.chat_room_members am
where am.room_id = chat_room_members.room_id
and am.user_id = auth.uid()
and am.role in ('owner','admin')
)
);

-- ---- chat_messages ----
drop policy if exists "read messages in my rooms" on public.chat_messages;
create policy "read messages in my rooms"
on public.chat_messages
for select
using (
exists (
select 1 from public.chat_room_members m
where m.room_id = chat_messages.room_id
and m.user_id = auth.uid()
)
);

drop policy if exists "send message as member" on public.chat_messages;
create policy "send message as member"
on public.chat_messages
for insert
with check (
sender_id = auth.uid() and
exists (
select 1 from public.chat_room_members m
where m.room_id = chat_messages.room_id
and m.user_id = auth.uid()
)
);

-- 작성자만 수정/소프트삭제 허용(운영 정책에 따라 admin 허용 가능)
drop policy if exists "edit my message" on public.chat_messages;
create policy "edit my message"
on public.chat_messages
for update
using (sender_id = auth.uid())
with check (sender_id = auth.uid());

drop policy if exists "delete my message" on public.chat_messages;
create policy "delete my message"
on public.chat_messages
for delete
using (sender_id = auth.uid());

-- ---- chat_message_reads ----
drop policy if exists "read receipts visible to room members" on public.chat_message_reads;
create policy "read receipts visible to room members"
on public.chat_message_reads
for select
using (
exists (
select 1
from public.chat_room_members m
join public.chat_messages msg on msg.room_id = m.room_id
where m.user_id = auth.uid()
and msg.id = chat_message_reads.message_id
)
);

drop policy if exists "mark my message as read" on public.chat_message_reads;
create policy "mark my message as read"
on public.chat_message_reads
for insert
with check (
user_id = auth.uid() and
exists (
select 1
from public.chat_room_members m
join public.chat_messages msg on msg.room_id = m.room_id
where m.user_id = auth.uid()
and msg.id = chat_message_reads.message_id
)
);