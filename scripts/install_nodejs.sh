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
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - || { echo -e "${RED}Error al configurar el repositorio de Node.js.${NC}"; exit 1; }
    apt-get install -y nodejs || { echo -e "${RED}Error al instalar Node.js.${NC}"; exit 1; }
    echo -e "${GREEN}Node.js instalado correctamente: $(node -v).${NC}"
fi

# Verificar si npm está instalado
if npm -v >/dev/null 2>&1; then
    echo -e "${GREEN}npm ya está instalado: $(npm -v).${NC}"
else
    echo -e "${GREEN}npm no está instalado. Procediendo con la instalación...${NC}"
    apt-get install -y npm || { echo -e "${RED}Error al instalar npm.${NC}"; exit 1; }
    echo -e "${GREEN}npm instalado correctamente: $(npm -v).${NC}"
fi

# Actualizar npm a una versión específica
desired_npm_version="10.9.0"
current_npm_version=$(npm -v)
if [ "$current_npm_version" != "$desired_npm_version" ]; then
    echo -e "${GREEN}Actualizando npm a la versión $desired_npm_version...${NC}"
    npm install -g npm@"$desired_npm_version" || { echo -e "${RED}Error al actualizar npm.${NC}"; exit 1; }
    echo -e "${GREEN}npm actualizado correctamente a la versión $(npm -v).${NC}"
else
    echo -e "${GREEN}npm ya está en la versión deseada: $current_npm_version.${NC}"
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

# Instalar dependencias de Node.js en el proyecto
if [ -f "/vagrant/package.json" ]; then
    echo -e "${GREEN}Instalando dependencias de Node.js en el proyecto...${NC}"
    cd /vagrant
    npm install || { echo -e "${RED}Error al instalar dependencias del proyecto.${NC}"; exit 1; }
else
    echo -e "${RED}No se encontró el archivo package.json en /vagrant. Saltando la instalación de dependencias.${NC}"
fi


# Verificar e instalar dependencias necesarias
declare -A DEPENDENCIES=(
    ["uglifyjs"]="uglify-js"
    ["csso"]="csso-cli"
    ["html-minifier-terser"]="html-minifier-terser"
)

echo -e "${GREEN}Verificando dependencias necesarias...${NC}"
for command in "${!DEPENDENCIES[@]}"; do
    if ! command -v "$command" &> /dev/null; then
        echo -e "${RED}$command no está instalado. Instalando...${NC}"
        npm install -g "${DEPENDENCIES[$command]}"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error al instalar ${DEPENDENCIES[$command]}.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}$command ya está instalado.${NC}"
    fi
done
echo -e "${GREEN}Herramientas de minificación instaladas correctamente.${NC}"

echo -e "${GREEN}Instalación y configuración completadas.${NC}"
