@echo off
REM Script de healthcheck para Windows

echo Verificando estado de servicios Docker...
echo.

set all_ok=1

echo Verificando Nginx (Web)...
curl -f -s -o nul http://localhost:8080
if %errorlevel% neq 0 (
    echo [ERROR] Nginx no responde
    set all_ok=0
) else (
    echo [OK] Nginx funcionando
)

echo Verificando API Gateway...
curl -f -s -o nul http://localhost:3210/health
if %errorlevel% neq 0 (
    echo [ERROR] API Gateway no responde
    set all_ok=0
) else (
    echo [OK] API Gateway funcionando
)

echo Verificando Authentication API...
curl -f -s -o nul http://localhost:4000/api/auth/health
if %errorlevel% neq 0 (
    echo [ERROR] Authentication API no responde
    set all_ok=0
) else (
    echo [OK] Authentication API funcionando
)

echo Verificando Authorization API...
curl -f -s -o nul http://localhost:5000/api/authorization/health
if %errorlevel% neq 0 (
    echo [ERROR] Authorization API no responde
    set all_ok=0
) else (
    echo [OK] Authorization API funcionando
)

echo Verificando User API...
curl -f -s -o nul http://localhost:6000/api/user/health
if %errorlevel% neq 0 (
    echo [ERROR] User API no responde
    set all_ok=0
) else (
    echo [OK] User API funcionando
)

echo.
echo ================================
if %all_ok%==1 (
    echo [OK] Todos los servicios estan funcionando correctamente
    exit /b 0
) else (
    echo [ERROR] Algunos servicios tienen problemas
    echo.
    echo Ejecuta 'docker-compose logs' para ver detalles
    exit /b 1
)
