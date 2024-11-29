#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Actualizar sistema
apt-get update

# Instalar HTML + JavaScript (index.html y directorio js)
chmod +x /vagrant/scripts/install_nginx.sh
bash /vagrant/scripts/install_nginx.sh
echo "Tecnología instalada: HTML + JavaScript"

# Instalar Node.js (package.json)
chmod +x /vagrant/scripts/install_nodejs.sh
bash /vagrant/scripts/install_nodejs.sh
echo "Tecnología instalada: Node.js"

# Instalar Git
chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh

echo "El servidor web está listo para usarse: http://localhost:8080/index.html"