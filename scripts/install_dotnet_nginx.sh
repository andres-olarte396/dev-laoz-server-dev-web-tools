#!/bin/bash

source ./messages.sh

# Actualizar los paquetes del sistema
msg_success "Actualizando paquetes del sistema..."
sudo apt-get update -y && sudo apt-get upgrade -y || { msg_success "Error al actualizar los paquetes."; exit 1; }

# Instalar dependencias requeridas
msg_success "Instalando dependencias..."
sudo apt-get install -y wget apt-transport-https software-properties-common || { msg_success "Error al instalar dependencias."; exit 1; }

# Agregar el repositorio de Microsoft para .NET
msg_success "Agregando el repositorio de Microsoft para .NET..."
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb || { msg_success "Error al descargar el repositorio de Microsoft."; exit 1; }
sudo dpkg -i packages-microsoft-prod.deb || { msg_success "Error al configurar el repositorio de Microsoft."; exit 1; }
rm -f packages-microsoft-prod.deb

# Instalar .NET SDK
msg_success "Instalando .NET SDK..."
sudo apt-get update -y
sudo apt-get install -y dotnet-sdk-7.0 || { msg_success "Error al instalar .NET SDK."; exit 1; }

# Verificar la instalación de .NET
dotnet_version=$(dotnet --version)
if [ $? -eq 0 ]; then
    msg_success ".NET SDK instalado correctamente: ${dotnet_version}"
else
    msg_success "Error al instalar .NET SDK."
    exit 1
fi

# Instalar y configurar un servidor web (Nginx)
msg_success "Instalando y configurando Nginx para hospedar aplicaciones .NET..."
sudo apt-get install -y nginx || { msg_success "Error al instalar Nginx."; exit 1; }

# Crear un archivo de configuración para la aplicación .NET
nginx_config="/etc/nginx/sites-available/dotnet-app"
msg_success "Creando configuración de Nginx para la aplicación .NET..."
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
sudo nginx -t || { msg_success "Error en la configuración de Nginx."; exit 1; }
sudo systemctl restart nginx || { msg_success "Error al reiniciar Nginx."; exit 1; }

# Configuración completada
msg_success "Instalación y configuración completadas:"
msg_info " - .NET SDK: $dotnet_version"
msg_info " - Servidor web: Nginx configurado para hospedar aplicaciones .NET"
