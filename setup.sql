-- ============================================================
-- CAMINA CONMIGO — Setup de base de datos en Supabase
-- Pegá TODO este archivo en: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- 1) Tabla de registros de caminata
create table if not exists entries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  steps integer not null,
  date date not null,
  time time,
  moment text,
  feeling smallint,
  photo_url text,
  created_at timestamptz not null default now()
);

-- 2) Seguridad: habilitar RLS (Row Level Security)
alter table entries enable row level security;

-- 3) Políticas: como no hay login de usuarios, el "anon key" público
--    puede insertar y leer registros (el link de la app es lo que
--    mantiene el acceso privado al grupo).
create policy "anon puede insertar registros"
on entries for insert
to anon
with check (true);

create policy "anon puede leer registros"
on entries for select
to anon
using (true);

-- 4) Bucket de Storage para las fotos de comprobación
insert into storage.buckets (id, name, public)
values ('walk-photos', 'walk-photos', true)
on conflict (id) do nothing;

-- 5) Políticas del bucket de fotos
create policy "anon puede subir fotos"
on storage.objects for insert
to anon
with check (bucket_id = 'walk-photos');

create policy "anon puede ver fotos"
on storage.objects for select
to anon
using (bucket_id = 'walk-photos');

-- ============================================================
-- Listo. Después de correr esto, andá a:
-- Project Settings → API → copiá "Project URL" y "anon public key"
-- y pegalos en index.html (líneas SUPABASE_URL y SUPABASE_ANON_KEY)
-- ============================================================
