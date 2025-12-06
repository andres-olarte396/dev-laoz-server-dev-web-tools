# Solución: Docker Desktop No Está Corriendo

## Problema Diagnosticado

El error `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified` indica que **Docker Desktop no está iniciado**.

- ✅ Docker CLI instalado: v28.5.1
- ❌ Docker Engine (daemon) no está corriendo

## Solución

### Opción 1: Iniciar Docker Desktop Manualmente (Recomendado)

1. **Busca "Docker Desktop" en el menú de inicio de Windows**
2. **Haz clic en el icono de Docker Desktop** para iniciarlo
3. **Espera** a que el ícono de Docker en la bandeja del sistema (system tray) muestre el estado "Docker Desktop is running"
   - Esto puede tomar 30-60 segundos
4. **Verifica** que Docker esté corriendo:
   ```powershell
   docker info
   ```
   Debe mostrar información del sistema sin errores

5. **Reinicia los contenedores**:
   ```powershell
   cd e:\MyRepos\dev-laoz-server-dev-web-tools
   docker-compose up -d
   ```

### Opción 2: Iniciar Docker Desktop desde PowerShell

```powershell
# Iniciar Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Esperar 30-60 segundos para que inicie completamente
Start-Sleep -Seconds 45

# Verificar que Docker esté corriendo
docker info

# Si no hay errores, iniciar los contenedores
cd e:\MyRepos\dev-laoz-server-dev-web-tools
docker-compose up -d
```

### Opción 3: Configurar Inicio Automático (Permanente)

Para que Docker Desktop inicie automáticamente al arrancar Windows:

1. Abre Docker Desktop
2. Haz clic en el ícono de engranaje (Settings)
3. Ve a la sección **General**
4. Marca la casilla **"Start Docker Desktop when you log in"**
5. Haz clic en **Apply & Restart**

## Cambios Aplicados

✅ **Corregido**: Removida la línea `version: '3.8'` del `docker-compose.yml` (obsoleta en versiones recientes de Docker Compose)

## Próximos Pasos

1. ✅ Inicia Docker Desktop
2. ⏳ Espera a que esté completamente iniciado
3. 🚀 Ejecuta `docker-compose up -d`
4. 📊 Verifica con `docker-compose ps`

## Comandos de Verificación

```powershell
# Verificar que Docker Desktop está corriendo
docker info

# Verificar versión de Docker Compose
docker-compose --version

# Ver estado de contenedores
docker-compose ps

# Ver logs si hay problemas
docker-compose logs
```

## Nota

Si Docker Desktop no se inicia o muestra errores, puede necesitar:
- Reiniciar tu computadora
- Verificar que WSL 2 esté instalado (Docker Desktop en Windows lo requiere)
- Verificar que la virtualización esté habilitada en la BIOS

Para más ayuda, consulta: https://docs.docker.com/desktop/troubleshoot/overview/
