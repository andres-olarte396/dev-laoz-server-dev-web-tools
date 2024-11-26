#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${GREEN}Inicio del proceso de instalación de nodejs y npm.${NC}"

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs
echo "Instalación de Node.js completada."

# Instalar npm
apt-get install -y npm

# Instalar una versión específica de npm
npm install -g npm@10.9.0

echo "Instalación de npm completada."

# Crear un archivo de configuración para el servidor Node.js
cat > /etc/systemd/system/node-server.service << EOF
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

# Habilitar y arrancar el servicio del servidor Node.js
systemctl enable node-server
systemctl start node-server

# Instalar dependencias de Node.js
cd /vagrant

# Instalar dependencias de Node.js
npm start

# Instalar herramientas de minificación
npm install -g uglify-js csso-cli html-minifier-terser

echo -e "${GREEN}Herramientas de minificación instaladas.${NC}"
