#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${GREEN}Inicio del proceso de instalación de nginx.${NC}"

# Instalar Nginx
apt-get install -y nginx
echo "Instalación de Nginx completada."

# Configurar Nginx para servir PHP
cat > /etc/nginx/sites-available/default << EOF
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
systemctl restart nginx

# Habilitar y reiniciar Nginx
systemctl enable nginx
systemctl start nginx

echo -e "${GREEN}El servidor web NGINX está listo para usarse: http://localhost:8080/index.php ${NC}"