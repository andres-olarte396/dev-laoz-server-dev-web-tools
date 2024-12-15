#!/bin/bash

# Definimos colores
RED='\033[0;31m'      # Rojo
GREEN='\033[0;32m'    # Verde
BLUE='\033[0;34m'     # Azul
YELLOW='\033[0;33m'   # Amarillo
NC='\033[0m'          # Sin color

# Función para obtener la fecha actual
get_current_date() {
    date "+%Y-%m-%d %H:%M:%S"  # Formato: Año-Mes-Día Hora:Minuto:Segundo
}

# Funciones para mensajes
msg_success() {
    local message=$1
    echo -e "$(get_current_date): ${GREEN} ✅ [SUCCESS] ${message}${NC}"
}

msg_error() {
    local message=$1
    echo -e "$(get_current_date): ${RED} ❌ [ERROR] ${message}${NC}"
}

msg_info() {
    local message=$1
    echo -e "$(get_current_date): ${BLUE} ℹ️ [INFO] ${message}${NC}"
}

msg_warning() {
    local message=$1
    echo -e "$(get_current_date): ${YELLOW} ⚠️ [WARNING] ${message}${NC}"
}

msg() {
    local message=$1
    echo -e "$(get_current_date): ${NC} 📧 ${message}"
}
