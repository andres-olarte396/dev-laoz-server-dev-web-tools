# Configuración Docker del Ecosistema WebTools

Este documento proporciona una guía completa para configurar y ejecutar el ecosistema WebTools usando Docker.

## Requisitos Previos

- **Docker Desktop** (Windows/Mac) o **Docker Engine** (Linux)
- **Docker Compose** v2.0 o superior
- Al menos 4GB de RAM disponible
- Puertos disponibles: 8080, 3210, 4000, 5000, 6000, 27017

## Instalación de Docker

### Windows
1. Descarga Docker Desktop desde [docker.com](https://www.docker.com/products/docker-desktop)
2. Ejecuta el instalador y sigue las instrucciones
3. Reinicia tu computadora si es necesario
4. Verifica la instalación: `docker --version` y `docker-compose --version`

### Linux
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

## Configuración Inicial

### 1. Variables de Entorno

Crea un archivo `.env` en el directorio `dev-laoz-server-dev-web-tools`:

```bash
cd dev-laoz-server-dev-web-tools
cp .env.example .env
```

Edita el archivo `.env` y actualiza:
- `JWT_SECRET`: Un string aleatorio seguro de al menos 32 caracteres

### 2. Verificar Estructura de Directorios

Asegúrate de que todos los repositorios estén en el mismo nivel:
```
MyRepos/
├── dev-laoz-server-dev-web-tools/
├── dev-laoz-api-gateway/
├── dev-laoz-authentication-api/
├── dev-laoz-authorization-api/
└── dev-laoz-api-user/
```

## Comandos Principales

### Iniciar el Ecosistema Completo

```bash
cd dev-laoz-server-dev-web-tools
docker-compose up -d
```

El flag `-d` ejecuta los contenedores en segundo plano (detached mode).

### Ver Logs de los Servicios

```bash
# Todos los servicios
docker-compose logs -f

# Un servicio específico
docker-compose logs -f api-gateway
docker-compose logs -f authentication-api
docker-compose logs -f mongodb
```

### Verificar Estado de los Servicios

```bash
docker-compose ps
```

Todos los servicios deben mostrar estado "Up" o "healthy".

### Detener el Ecosistema

```bash
# Detener sin eliminar contenedores ni volúmenes
docker-compose stop

# Detener y eliminar contenedores (mantiene volúmenes)
docker-compose down

# Detener, eliminar contenedores Y volúmenes (CUIDADO: elimina datos de MongoDB)
docker-compose down -v
```

### Reiniciar un Servicio Específico

```bash
docker-compose restart api-gateway
```

### Reconstruir Imágenes

Si modificas código o Dockerfiles:

```bash
# Reconstruir todas las imágenes
docker-compose build

# Reconstruir un servicio específico
docker-compose build authentication-api

# Reconstruir y reiniciar
docker-compose up -d --build
```

## Acceso a los Servicios

Una vez iniciados los contenedores:

- **Aplicación Web**: http://localhost:8080
- **API Gateway**: http://localhost:3210
- **Authentication API**: http://localhost:4000 (solo para desarrollo/debug)
- **MongoDB**: `mongodb://localhost:27017` (solo para desarrollo/debug)

## Gestión de Datos

### Backup de MongoDB

```bash
docker-compose exec mongodb mongodump --out=/data/backup
docker cp webtools-mongodb:/data/backup ./backup
```

### Restaurar MongoDB

```bash
docker cp ./backup webtools-mongodb:/data/backup
docker-compose exec mongodb mongorestore /data/backup
```

### Ver Datos en MongoDB

```bash
docker-compose exec mongodb mongosh
```

Dentro del shell de MongoDB:
```javascript
use webtools
show collections
db.users.find()
```

## Desarrollo

### Modo Desarrollo con Hot Reload

Los volúmenes en `docker-compose.yml` están configurados para montar el código local. Cualquier cambio en el código se reflejará automáticamente si tus servicios usan `nodemon`.

Para habilitar nodemon, actualiza el `CMD` en los Dockerfiles:
```dockerfile
CMD ["npx", "nodemon", "src/server.js"]
```

Luego reconstruye:
```bash
docker-compose up -d --build
```

### Acceder a un Contenedor

```bash
docker-compose exec api-gateway sh
```

## Troubleshooting

### Los servicios no inician

1. Verifica que Docker Desktop esté corriendo
2. Revisa los logs: `docker-compose logs`
3. Verifica puertos disponibles: `docker-compose ps`

### Error de conexión a MongoDB

```bash
# Verificar que MongoDB esté corriendo
docker-compose ps mongodb

# Ver logs de MongoDB
docker-compose logs mongodb

# Reiniciar MongoDB
docker-compose restart mongodb
```

### Limpiar Todo y Empezar de Cero

```bash
# Detener y eliminar todo
docker-compose down -v

# Eliminar imágenes
docker-compose rm -f
docker rmi $(docker images 'webtools-*' -q)

# Volver a construir e iniciar
docker-compose up -d --build
```

### Errores de Permisos (Linux)

```bash
sudo chown -R $USER:$USER .
```

### Contenedores consumen mucha RAM

Ajusta los límites de memoria en `docker-compose.yml`:

```yaml
services:
  mongodb:
    deploy:
      resources:
        limits:
          memory: 512M
```

## Mejores Prácticas

1. **No uses `docker-compose down -v` a menos que quieras eliminar todos los datos**
2. **Haz backups regulares de MongoDB antes de cambios importantes**
3. **Usa `.env` para configuraciones sensibles, nunca las incluyas en el código**
4. **Revisa logs regularmente**: `docker-compose logs --tail=100`
5. **Monitorea recursos**: `docker stats`

## Comandos Útiles Adicionales

```bash
# Ver uso de recursos
docker stats

# Limpiar imágenes sin usar
docker image prune -a

# Limpiar todo (contenedores, redes, volúmenes sin usar)
docker system prune -a --volumes

# Ver redes
docker network ls

# Inspeccionar un contenedor
docker inspect webtools-api-gateway
```

## Diferencias con Vagrant

| Aspecto | Vagrant | Docker |
|---------|---------|--------|
| Inicio | `vagrant up` | `docker-compose up -d` |
| Detener | `vagrant halt` | `docker-compose stop` |
| SSH | `vagrant ssh` | `docker-compose exec [servicio] sh` |
| Logs | Dentro de la VM | `docker-compose logs` |
| Recursos | VM completa (pesado) | Contenedores (ligero) |
| Portabilidad | Requiere VirtualBox | Solo Docker |

## Próximos Pasos

1. Personaliza las variables de entorno en `.env`
2. Inicia el ecosistema: `docker-compose up -d`
3. Verifica que todos los servicios estén corriendo: `docker-compose ps`
4. Accede a la aplicación web: http://localhost:8080
5. Prueba las APIs: http://localhost:3210

---

Para más información, consulta la [documentación oficial de Docker](https://docs.docker.com/).
