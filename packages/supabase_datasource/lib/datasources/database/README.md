# Supabase Type Generation

1. 함수 정의

```
CREATE OR REPLACE FUNCTION public.get_schema_info ()
RETURNS TABLE (
  table_name text,
  column_name text,
  data_type text,
  udt_name text,
  is_nullable text,
  column_default text,
  is_array boolean,
  element_type text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.table_name::text,
    c.column_name::text,
    c.data_type::text,
    c.udt_name::text,
    c.is_nullable::text,
    c.column_default::text,
    (c.data_type = 'ARRAY') AS is_array,
    e.data_type::text as element_type
  FROM information_schema.columns c
  LEFT JOIN information_schema.element_types e ON (
    (c.table_catalog, c.table_schema, c.table_name, 'TABLE', c.dtd_identifier)
    = (e.object_catalog, e.object_schema, e.object_name, e.object_type, e.collection_type_identifier))
  WHERE c.table_schema = 'public'
    AND c.table_name NOT LIKE 'pg_%'
    AND c.table_name NOT LIKE '_prisma_%'
  ORDER BY c.table_name, c.ordinal_position;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_schema_info () TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.get_enum_types ()
RETURNS TABLE (
  enum_schema text,
  enum_name   text,
  enum_value  text
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    n.nspname::text  AS enum_schema,
    t.typname::text  AS enum_name,
    e.enumlabel::text AS enum_value
  FROM pg_type t
  JOIN pg_enum e ON t.oid = e.enumtypid
  JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
  WHERE n.nspname = 'public'
  ORDER BY t.typname, e.enumsortorder;
$$;

GRANT EXECUTE ON FUNCTION public.get_enum_types () TO anon, authenticated, service_role;

NOTIFY pgrst, 'reload schema';
```

2. .env.codgen 파일 작성
```
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_KEY=<SUPABSE_SERVICE_KEY>
```

3. pubspec.yaml파일 수정
```
supabase_codegen:
  env: .env.codegen # 환경변수 파일 경로
  output: lib/datasource/database # generated된 파일 저장경로
  tag: v1 
  debug: true
  skipFooter: true
```

4. Code Generation
```
 flutter pub run supabase_codegen:generate_types \              
  --env .env.codegen
  --schema public
  -d
```