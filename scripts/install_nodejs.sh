#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${GREEN}Inicio del proceso de instalación o actualización de Node.js y npm.${NC}"

# Verificar si Node.js está instalado
if node -v >/dev/null 2>&1; then
    echo -e "${GREEN}Node.js ya está instalado: $(node -v).${NC}"
else
    echo -e "${GREEN}Node.js no está instalado. Procediendo con la instalación...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_current.x | sudo bash -
    sudo apt-get install -y nodejs
    echo -e "${GREEN}Node.js instalado correctamente: $(node -v).${NC}"
fi

# Verificar si npm está instalado
if npm -v >/dev/null 2>&1; then
    echo -e "${GREEN}npm ya está instalado: $(npm -v).${NC}"
else
    echo -e "${GREEN}npm no está instalado. Procediendo con la instalación...${NC}"
    # Instalar una ultima versión de npm
    npm install -g npm@latest
    echo -e "${GREEN}npm instalado correctamente: $(npm -v).${NC}"
fi

# Crear archivo de configuración del servicio Node.js solo si no existe
node_service_path="/etc/systemd/system/node-server.service"
if [ -f "$node_service_path" ]; then
    echo -e "${GREEN}El archivo de servicio de Node.js ya existe. No se realizan cambios.${NC}"
else
    echo -e "${GREEN}Creando archivo de servicio para Node.js...${NC}"
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
    echo -e "${GREEN}Archivo de servicio creado correctamente.${NC}"
fi

# Habilitar y arrancar el servicio del servidor Node.js
echo -e "${GREEN}Habilitando y arrancando el servicio Node.js...${NC}"
systemctl enable node-server || { echo -e "${RED}Error al habilitar el servicio de Node.js.${NC}"; exit 1; }
systemctl start node-server || { echo -e "${RED}Error al iniciar el servicio de Node.js.${NC}"; exit 1; }

# Instalar herramientas de minificación solo si no están instaladas
echo -e "${GREEN}Instalando herramientas de minificación...${NC}"
npm list -g html-minifier-terser >/dev/null 2>&1 || npm install -g html-minifier-terser || { echo -e "${RED}Error al instalar html-minifier-terser.${NC}"; exit 1; }
npm list -g csso-cli >/dev/null 2>&1 || npm install -g csso-cli || { echo -e "${RED}Error al instalar csso-cli.${NC}"; exit 1; }
npm list -g uglify-js >/dev/null 2>&1 || npm install -g uglify-js || { echo -e "${RED}Error al instalar uglify-js.${NC}"; exit 1; }
echo -e "${GREEN}Herramientas de minificación instaladas correctamente.${NC}"


echo -e "${GREEN}Instalación y configuración completadas.${NC}"
