#!/bin/bash

source ./messages.sh

# Actualizar sistema
apt-get update

# Instalar HTML + JavaScript (index.html y directorio js)
chmod +x /vagrant/scripts/install_nginx.sh
bash /vagrant/scripts/install_nginx.sh
msg_info "Tecnología instalada: HTML + JavaScript"

# Instalar Node.js (package.json)
chmod +x /vagrant/scripts/install_nodejs.sh
bash /vagrant/scripts/install_nodejs.sh
msg_info "Tecnología instalada: Node.js"

# Instalar PHP (index.php)
chmod +x /vagrant/scripts/install_php.sh
bash /vagrant/scripts/install_php.sh
msg_info "Tecnología instalada: PHP"

# Instalar Git
chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh

msg_info "El servidor web está listo para usarse: http://localhost:8080/index.html"