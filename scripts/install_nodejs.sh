#!/bin/bash
source /vagrant/scripts/messages.sh

msg_success "Inicio del proceso de instalación o actualización de Node.js y npm."
# Verificar si Node.js está instalado
if node -v >/dev/null 2>&1; then
    msg_warning "Node.js ya está instalado: $(node -v)."
else
    msg_info "Node.js no está instalado. Procediendo con la instalación..."
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo bash -
    sudo apt-get install -y nodejs
    msg_success "Node.js instalado correctamente: $(node -v)."
fi

# Verificar si npm está instalado
if npm -v >/dev/null 2>&1; then
    msg_warning "npm ya está instalado: $(npm -v)."
else
    msg_info "npm no está instalado. Procediendo con la instalación..."
    # Instalar una ultima versión de npm
    npm install -g npm@latest
    msg_success "npm instalado correctamente: $(npm -v)."
fi

# Instalar herramientas de minificación solo si no están instaladas
msg_info "Instalando herramientas de minificación..."
npm list -g html-minifier-terser >/dev/null 2>&1 || npm install -g html-minifier-terser || { msg_error "Error al instalar html-minifier-terser."; exit 1; }
npm list -g csso-cli >/dev/null 2>&1 || npm install -g csso-cli || { msg_error "Error al instalar csso-cli."; exit 1; }
npm list -g uglify-js >/dev/null 2>&1 || npm install -g uglify-js || { msg_error "Error al instalar uglify-js."; exit 1; }
msg_info "Herramientas de minificación instaladas correctamente."

# Crear archivo de configuración del servicio Node.js solo si no existe
node_service_path="/etc/systemd/system/node-server.service"
if [ -f "$node_service_path" ]; then
    msg_warning "El archivo de servicio de Node.js ya existe. No se realizan cambios."
else
    msg_info "Creando archivo de servicio para Node.js..."
    cat > "$node_service_path" << EOF
[Unit]
Description=Node.js Server
After=network.target

[Service]
ExecStart=/usr/bin/node /vagrant/server.js
Restart=always
User=vagrant
Group=vagrant
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/vagrant

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    msg_success "Archivo de servicio creado correctamente."
fi

# Habilitar y arrancar el servicio del servidor Node.js
msg_info "Habilitando y arrancando el servicio Node.js..."
systemctl enable node-server || { msg_error "Error al habilitar el servicio de Node.js."; exit 1; }
systemctl start node-server || { msg_error "Error al iniciar el servicio de Node.js."; exit 1; }

# Mostrar mensaje de finalización
msg_success "Instalación y configuración completadas."