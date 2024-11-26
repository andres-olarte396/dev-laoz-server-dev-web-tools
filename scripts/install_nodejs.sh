#!/bin/bash

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

# Instalar herramientas de minificación
npm install -g uglify-js csso-cli html-minifier-terser

echo -e "${GREEN}Herramientas de minificación instaladas.${NC}"
