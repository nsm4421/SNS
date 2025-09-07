# Chat


```
-- ─────────────────────────────────────────────────────────
-- Extensions & Helpers
-- ─────────────────────────────────────────────────────────
create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

do $$
begin
  if not exists (select 1 from pg_type where typname = 'message_type') then
    create type message_type as enum ('text', 'image', 'file', 'system');
  end if;
end $$;

-- ─────────────────────────────────────────────────────────
-- Tables
-- ─────────────────────────────────────────────────────────
create table if not exists public.dm_conversations (
  id                 uuid primary key default gen_random_uuid(),
  -- NOTE: 필요시 public.users → auth.users 로 교체
  user1_id           uuid not null default auth.uid() references public.users(id) on delete cascade,
  user1_last_seen_at timestamptz,
  user2_id           uuid not null references public.users(id) on delete cascade,
  user2_last_seen_at timestamptz,
  last_message_at    timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  constraint dm_pair_distinct check (user1_id <> user2_id),
  constraint dm_pair_unique unique (user1_id, user2_id)
);

create table if not exists public.dm_messages (
  id               uuid primary key default gen_random_uuid(),
  conversation_id  uuid not null references public.dm_conversations(id) on delete cascade,
  sender_id        uuid not null default auth.uid() references public.users(id) on delete cascade,
  type             message_type not null default 'text',
  content          text,
  metadata         jsonb not null default '{}'::jsonb,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  constraint messages_text_requires_content
    check (type <> 'text' or (content is not null and btrim(content) <> ''))
);

-- ─────────────────────────────────────────────────────────
-- Triggers (canonicalize pair / updated_at / bump last_message_at)
-- ─────────────────────────────────────────────────────────

-- user1_id < user2_id 로 정규화(중복 방지)
create or replace function public.dm_canonicalize_pair()
returns trigger language plpgsql as $$
declare tmp uuid;
begin
  if new.user1_id = new.user2_id then
    raise exception 'user1_id and user2_id must be different';
  end if;

  if new.user1_id > new.user2_id then
    tmp := new.user1_id;
    new.user1_id := new.user2_id;
    new.user2_id := tmp;
  end if;

  return new;
end $$;

drop trigger if exists trg_dm_canonicalize_pair on public.dm_conversations;
create trigger trg_dm_canonicalize_pair
before insert on public.dm_conversations
for each row execute function public.dm_canonicalize_pair();

-- updated_at 자동 갱신
drop trigger if exists trg_dm_conversations_set_updated_at on public.dm_conversations;
create trigger trg_dm_conversations_set_updated_at
before update on public.dm_conversations
for each row execute function public.set_updated_at();

drop trigger if exists trg_dm_messages_set_updated_at on public.dm_messages;
create trigger trg_dm_messages_set_updated_at
before update on public.dm_messages
for each row execute function public.set_updated_at();

-- 새 메시지 시 last_message_at 갱신
create or replace function public.bump_dm_last_message_at()
returns trigger language plpgsql as $$
begin
  update public.dm_conversations
     set last_message_at = greatest(coalesce(last_message_at, 'epoch'), new.created_at),
         updated_at      = now()
   where id = new.conversation_id;
  return new;
end $$;

drop trigger if exists trg_dm_messages_bump_last on public.dm_messages;
create trigger trg_dm_messages_bump_last
after insert on public.dm_messages
for each row execute function public.bump_dm_last_message_at();

-- ─────────────────────────────────────────────────────────
-- Indexes
-- ─────────────────────────────────────────────────────────
create index if not exists idx_dm_conversations_last_message_at on public.dm_conversations(last_message_at desc);
create index if not exists idx_dm_conversations_user_id1 on public.dm_conversations(user1_id);
create index if not exists idx_dm_conversations_user_id2 on public.dm_conversations(user2_id);

-- 목록 최적화(강추)
create index if not exists idx_dm_conv_u1_last on public.dm_conversations(user1_id, last_message_at desc);
create index if not exists idx_dm_conv_u2_last on public.dm_conversations(user2_id, last_message_at desc);

create index if not exists idx_messages_thread_time on public.dm_messages(conversation_id, created_at desc);
create index if not exists idx_messages_sender on public.dm_messages(sender_id);

-- ─────────────────────────────────────────────────────────
-- RLS
-- ─────────────────────────────────────────────────────────
alter table public.dm_conversations enable row level security;
alter table public.dm_messages enable row level security;

-- dm_conversations
drop policy if exists dm_conversations_select on public.dm_conversations;
create policy dm_conversations_select
on public.dm_conversations for select
using (auth.uid() in (user1_id, user2_id));

drop policy if exists dm_conversations_insert on public.dm_conversations;
create policy dm_conversations_insert
on public.dm_conversations for insert
with check (auth.uid() in (user1_id, user2_id));

drop policy if exists dm_conversations_update on public.dm_conversations;
create policy dm_conversations_update
on public.dm_conversations for update
using (auth.uid() in (user1_id, user2_id))
with check (auth.uid() in (user1_id, user2_id));

drop policy if exists dm_conversations_delete on public.dm_conversations;
create policy dm_conversations_delete
on public.dm_conversations for delete
using (auth.uid() in (user1_id, user2_id));

-- dm_messages
drop policy if exists messages_select on public.dm_messages;
create policy messages_select
on public.dm_messages for select
using (
  exists (
    select 1 from public.dm_conversations c
    where c.id = dm_messages.conversation_id
      and auth.uid() in (c.user1_id, c.user2_id)
  )
);

drop policy if exists messages_insert on public.dm_messages;
create policy messages_insert
on public.dm_messages for insert
with check (
  auth.uid() = sender_id
  and exists (
    select 1 from public.dm_conversations c
    where c.id = dm_messages.conversation_id
      and auth.uid() in (c.user1_id, c.user2_id)
  )
);

drop policy if exists messages_update on public.dm_messages;
create policy messages_update
on public.dm_messages for update
using (auth.uid() = sender_id)
with check (auth.uid() = sender_id);

drop policy if exists messages_delete on public.dm_messages;
create policy messages_delete
on public.dm_messages for delete
using (auth.uid() = sender_id);

-- view
create or replace view public.dm_conversations_with_user as
select
  c.id as conversation_id,

  case
    when auth.uid() = c.user1_id then c.user2_id
    when auth.uid() = c.user2_id then c.user1_id
  end                                       as other_user_id,

  -- 상대방 프로필(프로필 테이블 사용)
  u.username                                as other_username,

  -- 마지막 메시지(있으면)
  lm.id                                     as last_message_id,
  lm.sender_id                              as last_message_sender_id,
  lm.type                                   as last_message_type,
  lm.content                                as last_message_content,
  lm.created_at                             as last_message_created_at,

  -- 정렬/읽음 지표
  c.last_message_at,
  case when auth.uid() = c.user1_id then c.user1_last_seen_at else c.user2_last_seen_at end
                                            as my_last_seen_at

from public.dm_conversations c
-- 상대 프로필 조인: 내 포지션에 따라 상대를 계산해서 조인
join public.users u
  on u.id = case when auth.uid() = c.user1_id then c.user2_id else c.user1_id end

-- 마지막 메시지 1건 (LATERAL)
left join lateral (
  select m.id, m.sender_id, m.type, m.content, m.created_at
  from public.dm_messages m
  where m.conversation_id = c.id
  order by m.created_at desc
  limit 1
) lm on true

-- 내가 멤버인 대화만
where auth.uid() in (c.user1_id, c.user2_id);

-- channel 사용 시 old 데이터 조회를 위해 설정 추가
alter table public.dm_messages      replica identity full;
alter table public.dm_conversations replica identity full;
```