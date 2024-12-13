#!/bin/bash

# Definimos colores
RED='\033[0;31m'      # Rojo
GREEN='\033[0;32m'    # Verde
BLUE='\033[0;34m'     # Azul
YELLOW='\033[0;33m'   # Amarillo
NC='\033[0m'          # Sin color

# Funciones para mensajes
msg_success() {
    local message=$1
    echo -e "\n${GREEN}✅ [SUCCESS]: ${message}${NC}"
}

msg_error() {
    local message=$1
    echo -e "\n${RED}❌ [ERROR]: ${message}${NC}"
}

msg_info() {
    local message=$1
    echo -e "\n${BLUE}ℹ️ [INFO]: ${message}${NC}"
}

msg_warning() {
    local message=$1
    echo -e "\n${YELLOW}⚠️ [WARNING]: ${message}${NC}"
}