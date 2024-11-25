#!/bin/bash

# Actualizar sistema
apt-get update

# Instalar Nginx
apt-get install -y nginx

# Instalar PHP y extensiones necesarias
apt-get install -y php-fpm php-mbstring curl git

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

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

# Asegurarse de que PHP-FPM esté corriendo
systemctl enable php7.4-fpm
systemctl start php7.4-fpm

# Crear un ejemplo index.php
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Instalar dependencias necesarias
apt-get install -y nginx git nodejs npm

# Instalar una versión específica de npm
npm install -g npm@10.9.0

# Instalar herramientas de minificación
npm install -g uglify-js csso-cli html-minifier-terser

# Crear la carpeta donde se clonarán los proyectos
mkdir -p /var/www/html

# Habilitar y reiniciar Nginx
systemctl enable nginx
systemctl start nginx

# Dar permisos de ejecución al script
chmod +x /vagrant/scripts/load-git-repos.sh

# Ejecutar el script para clonar los repositorios
bash /vagrant/scripts/load-git-repos.sh

# Dar permisos de ejecución al script de minificación
chmod +x /vagrant/scripts/minify-files.sh

# Ejecutar el script de minificación
bash /vagrant/scripts/minify-files.sh

echo "El servidor web está listo para usarse: http://localhost:8080/index.html"