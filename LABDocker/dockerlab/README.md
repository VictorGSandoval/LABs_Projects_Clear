# dockerlab

## Instrucciones

Desarrolla un microservicio en Spring Boot con las siguientes condiciones:

### Requisitos funcionales

- No debe usar base de datos.
- Exponer el endpoint `GET /prueba`.
- El JSON devuelto debe contener 3 campos:
  - `id` (ej. RUC)
  - `nombre` (institución)
  - `correoContacto` (correo ficticio)
- Usar el puerto `8085` si no existe la variable de entorno `$PORT`.

### Proceso

1. Genera el `.JAR` del microservicio.
2. Crea el `Dockerfile` usando **multistage** (obligatorio).
3. Publica la imagen en **DockerHub** cumpliendo con:
   - Tag obligatorio: `3.0`
   - Imagen **NO** basada en Ubuntu, Debian o CentOS.
   - No usar `ENV` en el Dockerfile.
   - (Opcional) No usar usuario root.
   - (Opcional) Optimizar el tamaño de la imagen.
4. Crea un archivo `docker-compose.yml` funcional que levante el contenedor.
5. Publica el código completo en un repositorio público en GitHub, incluyendo:
   - Código fuente del microservicio
   - `.jar` generado
   - `Dockerfile`
   - `docker-compose.yml`

### Entrega obligatoria en este Google Sheet:

https://docs.google.com/spreadsheets/d/1Nv3fVP8ZD_1s2P72M4CGZ8acUQj95ikw7F10JlQv9mU/edit?usp=sharing

### Cabeceras a completar en el Sheet:
- Nombre y Apellido
- Correo
- Institución
- ID (RUC)
- Correo de contacto (ficticio)
- URL imagen
- DockerHub Imagen
- URL raw Dockerfile
- URL raw docker-compose.yml
- URL de Repositorio GitHub