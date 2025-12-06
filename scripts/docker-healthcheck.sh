#!/bin/bash
# Script de healthcheck para Docker Compose

echo "🔍 Verificando estado de servicios Docker..."
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Función para verificar un servicio
check_service() {
    local service_name=$1
    local url=$2
    
    echo -n "Verificando $service_name... "
    
    if curl -f -s -o /dev/null "$url"; then
        echo -e "${GREEN}✓ OK${NC}"
        return 0
    else
        echo -e "${RED}✗ FALLO${NC}"
        return 1
    fi
}

# Verificar servicios
all_ok=true

check_service "Nginx (Web)" "http://localhost:8080" || all_ok=false
check_service "API Gateway" "http://localhost:3210/health" || all_ok=false
check_service "Authentication API" "http://localhost:4000/api/auth/health" || all_ok=false
check_service "Authorization API" "http://localhost:5000/api/authorization/health" || all_ok=false
check_service "User API" "http://localhost:6000/api/user/health" || all_ok=false

# Verificar MongoDB
echo -n "Verificando MongoDB... "
if docker exec webtools-mongodb mongosh --quiet --eval "db.adminCommand('ping').ok" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FALLO${NC}"
    all_ok=false
fi

echo ""
echo "================================"
if [ "$all_ok" = true ]; then
    echo -e "${GREEN}✓ Todos los servicios están funcionando correctamente${NC}"
    exit 0
else
    echo -e "${RED}✗ Algunos servicios tienen problemas${NC}"
    echo ""
    echo "Ejecuta 'docker-compose logs' para ver detalles"
    exit 1
fi
