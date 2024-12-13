#!/bin/bash

source ./messages.sh

msg_success "Inicio del proceso de instalación o actualización de Nginx."

# Verificar si Nginx está instalado
if dpkg -l | grep -q nginx; then
    msg_success "Nginx ya está instalado. Verificando actualizaciones..."
    apt-get install --only-upgrade -y nginx || { msg_success "Error al actualizar Nginx."; exit 1; }
else
    msg_success "Nginx no está instalado. Procediendo con la instalación..."
    apt-get install -y nginx || { msg_success "Error al instalar Nginx."; exit 1; }
fi

# Configurar Nginx para servir PHP solo si no está configurado
nginx_config="/etc/nginx/sites-available/default"
if grep -q "fastcgi_pass" "$nginx_config"; then
    msg_success "La configuración de Nginx para PHP ya existe. No se realizan cambios."
else
    msg_success "Creando configuración de Nginx para servir PHP..."
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
    msg_success "Reiniciando Nginx para aplicar cambios..."
    systemctl restart nginx || { msg_success "Error al reiniciar Nginx."; exit 1; }
fi

# Habilitar y asegurar que Nginx está en ejecución
msg_success "Asegurando que Nginx está habilitado y en ejecución..."
systemctl enable nginx || { msg_success "Error al habilitar Nginx."; exit 1; }
systemctl start nginx || { msg_success "Error al iniciar Nginx."; exit 1; }

msg_success "El servidor web NGINX está listo para usarse: http://localhost/index.php "
