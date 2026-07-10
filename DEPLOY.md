# Camina Conmigo — Guía de despliegue

## 1) Supabase (base de datos)
1. Entrá a tu proyecto en supabase.com (o creá uno nuevo, plan Free).
2. Menú lateral → **SQL Editor** → **New query**.
3. Pegá todo el contenido de `setup.sql` y tocá **Run**. Esto crea la tabla `entries` y el bucket de fotos `walk-photos` con los permisos correctos.
4. Andá a **Project Settings → API**. Copiá:
   - **Project URL**
   - **anon public key**
5. Abrí `index.html`, buscá estas líneas cerca del principio del `<script>` y reemplazalas:
   ```js
   const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';
   const SUPABASE_ANON_KEY = 'TU_ANON_KEY_AQUI';
   ```

## 2) GitHub (repositorio)
```bash
cd carpeta-del-proyecto
git init
git add .
git commit -m "Camina Conmigo - primera versión"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/camina-conmigo.git
git push -u origin main
```
(Creá antes el repo vacío en github.com → "New repository", sin README, y copiá esa URL en el `remote add`.)

## 3) Netlify (hosting)
1. netlify.app → **Add new site → Import an existing project**.
2. Elegí **GitHub** y seleccioná el repo `camina-conmigo`.
3. Build settings:
   - **Build command:** dejar vacío
   - **Publish directory:** `.` (la raíz)
4. **Deploy site**. En un minuto ya tenés una URL tipo `nombre-random.netlify.app` funcionando y con base de datos real.

## 4) Dominio propio
1. En Netlify: **Site configuration → Domain management → Add a domain**.
2. Escribí tu dominio (ej: `caminaconmigo.com`).
3. Netlify te muestra los registros DNS a configurar. Las dos formas más comunes:
   - **Opción fácil:** cambiar los nameservers del dominio a los de Netlify (ellos te dan 4 nameservers) en tu proveedor de dominios (GoDaddy, Namecheap, etc).
   - **Opción manual:** agregar un registro `CNAME` apuntando `www` → `nombre-random.netlify.app`, y un registro `A` para el dominio raíz apuntando a la IP que te indique Netlify.
4. Netlify emite el certificado HTTPS automáticamente en unos minutos una vez que el DNS propague (puede tardar hasta 24hs).

## Notas importantes
- **Cada vez que quieras actualizar la app** (por ejemplo si yo te paso un archivo `index.html` nuevo con cambios), solo tenés que reemplazar el archivo en tu carpeta local, hacer `git add . && git commit -m "update" && git push`, y Netlify redespliega solo, automáticamente.
- El nombre de cada alumna se guarda en el navegador de su celular (localStorage). Si borra los datos del navegador o cambia de celular, va a tener que volver a escribir su nombre — sus registros previos siguen intactos en la base de datos porque están asociados al nombre, no al dispositivo.
- Las fotos se guardan en el bucket `walk-photos` de Supabase. En el plan free tenés 1GB de almacenamiento de archivos — para referencia, con fotos comprimidas como las que genera la app (~30-60KB c/u), eso alcanza para miles de caminatas.
- Backup de datos: desde Supabase → **Table Editor → entries → Export → CSV**, podés descargar todos los registros en cualquier momento.
