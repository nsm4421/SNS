# Users

### DDL

```plpgsql
-- public.users테이블 생성
create table if not exists public.users (
    id uuid primary key references auth.users(id) on delete cascade
    , username text unique not null
    , created_at timestamp with time zone default timezone('utc'::text, now()) not null
    , updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 회원가입 시(auth.users테이블에 insert시) public.users 테이블에 insert하도록 설정
create or replace function public.handle_insert_on_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, username)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'username'
    )
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_inserted
after insert on auth.users
for each row
execute procedure public.handle_insert_on_auth_user();

-- username이 변경될 때(auth.users테이블의 raw_user_meta_data필드가 업데이트 될 때), public.users 테이블도 업데이트
create or replace function public.handle_updated_on_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.users
  set username = coalesce(new.raw_user_meta_data->>'username', username)
  where id = new.id;

  return new;
end;
$$;

create trigger on_auth_user_updated
after update of raw_user_meta_data on auth.users
for each row
execute procedure public.handle_updated_on_auth_user();

-- public.users테이블 update시, updated_at필드에 update
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

create trigger set_users_updated_at
before update on public.users
for each row
execute procedure public.set_updated_at();

-- RLS설정
alter table public.users enable row level security;

create policy "Users are viewable by authenticated users"
on public.users
for select
using (auth.role() = 'authenticated');

create policy "Users can insert their own row"
on public.users
for insert
with check (auth.uid() = id);

create policy "Users can update their own row"
on public.users
for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can delete their own row"
on public.users
for delete
using (auth.uid() = id);
```
