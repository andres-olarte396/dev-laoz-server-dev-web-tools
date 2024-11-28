#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Actualizar los paquetes del sistema
echo -e "${GREEN}Actualizando paquetes del sistema...${NC}"
sudo apt-get update -y && sudo apt-get upgrade -y || { echo -e "${RED}Error al actualizar los paquetes.${NC}"; exit 1; }

# Instalar dependencias requeridas
echo -e "${GREEN}Instalando dependencias...${NC}"
sudo apt-get install -y wget apt-transport-https software-properties-common || { echo -e "${RED}Error al instalar dependencias.${NC}"; exit 1; }

# Agregar el repositorio de Microsoft para .NET
echo -e "${GREEN}Agregando el repositorio de Microsoft para .NET...${NC}"
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb || { echo -e "${RED}Error al descargar el repositorio de Microsoft.${NC}"; exit 1; }
sudo dpkg -i packages-microsoft-prod.deb || { echo -e "${RED}Error al configurar el repositorio de Microsoft.${NC}"; exit 1; }
rm -f packages-microsoft-prod.deb

# Instalar .NET SDK
echo -e "${GREEN}Instalando .NET SDK...${NC}"
sudo apt-get update -y
sudo apt-get install -y dotnet-sdk-7.0 || { echo -e "${RED}Error al instalar .NET SDK.${NC}"; exit 1; }

# Verificar la instalación de .NET
dotnet_version=$(dotnet --version)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}.NET SDK instalado correctamente: ${dotnet_version}${NC}"
else
    echo -e "${RED}Error al instalar .NET SDK.${NC}"
    exit 1
fi

# Instalar y configurar un servidor web (Nginx)
echo -e "${GREEN}Instalando y configurando Nginx para hospedar aplicaciones .NET...${NC}"
sudo apt-get install -y nginx || { echo -e "${RED}Error al instalar Nginx.${NC}"; exit 1; }

# Crear un archivo de configuración para la aplicación .NET
nginx_config="/etc/nginx/sites-available/dotnet-app"
echo -e "${GREEN}Creando configuración de Nginx para la aplicación .NET...${NC}"
sudo bash -c "cat > $nginx_config" <<EOL
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Habilitar la configuración de Nginx
sudo ln -s $nginx_config /etc/nginx/sites-enabled/
sudo nginx -t || { echo -e "${RED}Error en la configuración de Nginx.${NC}"; exit 1; }
sudo systemctl restart nginx || { echo -e "${RED}Error al reiniciar Nginx.${NC}"; exit 1; }

# Configuración completada
echo -e "${GREEN}Instalación y configuración completadas:${NC}"
echo " - .NET SDK: $dotnet_version"
echo " - Servidor web: Nginx configurado para hospedar aplicaciones .NET"
