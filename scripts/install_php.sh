#!/bin/bash
source /vagrant/scripts/messages.sh

msg_success "Inicio del proceso de instalación de php. ."

# Instalar PHP y extensiones necesarias
apt-get install -y php-fpm php-mbstring curl php-curl php-gd php-xml php-xmlrpc php-zip php-mysql
msg_info "Instalación de PHP y extensiones completada."

# Asegurarse de que PHP-FPM esté corriendo
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

# Crear un ejemplo index.php
msg_info "<?php phpinfo(); ?>" > /var/www/html/index.php
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

msg_success "El servidor web PHP está listo para usarse: http://localhost:8080/index.php ."