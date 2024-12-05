#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${GREEN}Inicio del proceso de instalación o actualización de Nginx.${NC}"

# Verificar si Nginx está instalado
if dpkg -l | grep -q nginx; then
    echo -e "${GREEN}Nginx ya está instalado. Verificando actualizaciones...${NC}"
    apt-get install --only-upgrade -y nginx || { echo -e "${RED}Error al actualizar Nginx.${NC}"; exit 1; }
else
    echo -e "${GREEN}Nginx no está instalado. Procediendo con la instalación...${NC}"
    apt-get install -y nginx || { echo -e "${RED}Error al instalar Nginx.${NC}"; exit 1; }
fi

# Configurar Nginx para servir PHP solo si no está configurado
nginx_config="/etc/nginx/sites-available/default"
if grep -q "fastcgi_pass" "$nginx_config"; then
    echo -e "${GREEN}La configuración de Nginx para PHP ya existe. No se realizan cambios.${NC}"
else
    echo -e "${GREEN}Creando configuración de Nginx para servir PHP...${NC}"
    cat > "$nginx_config" << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

    # Reiniciar Nginx para aplicar cambios
    echo -e "${GREEN}Reiniciando Nginx para aplicar cambios...${NC}"
    systemctl restart nginx || { echo -e "${RED}Error al reiniciar Nginx.${NC}"; exit 1; }
fi

# Habilitar y asegurar que Nginx está en ejecución
echo -e "${GREEN}Asegurando que Nginx está habilitado y en ejecución...${NC}"
systemctl enable nginx || { echo -e "${RED}Error al habilitar Nginx.${NC}"; exit 1; }
systemctl start nginx || { echo -e "${RED}Error al iniciar Nginx.${NC}"; exit 1; }

echo -e "${GREEN}El servidor web NGINX está listo para usarse: http://localhost/index.php ${NC}"
