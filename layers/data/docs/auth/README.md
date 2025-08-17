# Auth

## Create User Table

```
create table if not exists public.users (
    id uuid primary key references auth.users(id) on delete cascade
    , username text unique not null check (char_length(username) >= 2)
    , profile_image text
    , created_at timestamp with time zone default timezone('utc'::text, now()) not null
    , updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
```

### RLS
```
alter table public.users enable row level security;

create policy "permit select for authenticated"
on public.users
for select
using (auth.role() = 'authenticated');

create policy "permit insert own data"
on public.users
for insert
with check (auth.uid() = id);

create policy "permit update own data"
on public.users
for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "delete update own data"
on public.users
for delete
using (auth.uid() = id);
```

## Trigger

회원가입 성공 시에 auth.users테이블에 insert 발생
이 때 public.users테이블에도 insert
```
create or replace function public.handle_insert_on_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, username, profile_image)
  values (
    new.id
    , coalesce(
      new.raw_user_meta_data->>'username'
    )
    , coalesce(
      new.raw_user_meta_data->>'profile_image'
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
```

update발생 시, updated_at필드 업데이트
```
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
execute procedure public.set_updated_at()
```