-- 대소문자 구분 없는 유니크 처리를 위해
create extension if not exists citext;

-- updated_at 자동 갱신 트리거
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
new.updated_at = now();
return new;
end $$;