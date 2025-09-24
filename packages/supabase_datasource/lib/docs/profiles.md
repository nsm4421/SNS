create table public.profiles (
user_id        uuid primary key
references auth.users(id) on delete cascade,
username       citext unique,                   -- @중복 방지(대소문자 무시)
display_name   text,
avatar_url     text,
bio            text,
status_message text,                            -- 상태메시지(선택)
last_seen_at   timestamptz,                     -- 마지막 접속(옵션)
created_at     timestamptz not null default now(),
updated_at     timestamptz not null default now(),

-- 사용자명 패턴(영문/숫자/밑줄, 3~20자 예시)
constraint username_format_chk
check (username is null or username ~ '^[a-zA-Z0-9_]{3,20}$')
);

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function set_updated_at();

-- 자주 찾는 필드에 보조 인덱스(선택)
create index if not exists idx_profiles_last_seen_at on public.profiles(last_seen_at desc);

alter table public.profiles enable row level security;

-- 누구나 프로필 읽기(공개)
create policy "profiles are public readable"
on public.profiles
for select
using (true);

-- 본인만 자신의 프로필 insert 가능
create policy "insert own profile"
on public.profiles
for insert
with check (auth.uid() = user_id);

-- 본인만 자신의 프로필 update 가능
create policy "update own profile"
on public.profiles
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
insert into public.profiles (user_id, display_name)
values (new.id, coalesce(new.raw_user_meta_data->>'name', ''));
return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();

