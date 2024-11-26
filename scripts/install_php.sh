#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${GREEN}Inicio del proceso de instalación de php. .${NC}"

# Instalar PHP y extensiones necesarias
apt-get install -y php-fpm php-mbstring curl php-curl php-gd php-xml php-xmlrpc php-zip php-mysql
echo "Instalación de PHP y extensiones completada."

# Asegurarse de que PHP-FPM esté corriendo
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

# Crear un ejemplo index.php
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo -e "${GREEN}El servidor web PHP está listo para usarse: http://localhost:8080/index.php .${NC}"