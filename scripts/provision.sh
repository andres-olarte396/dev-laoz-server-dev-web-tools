#!/bin/bash
source /vagrant/scripts/messages.sh

# Actualizar sistema
apt-get update

# Instalar HTML + JavaScript (index.html y directorio js)
chmod +x /vagrant/scripts/install_nginx.sh
bash /vagrant/scripts/install_nginx.sh
msg_success "Tecnología instalada: HTML + JavaScript"

# Instalar Node.js (package.json)
chmod +x /vagrant/scripts/install_nodejs.sh
bash /vagrant/scripts/install_nodejs.sh
msg_success "Tecnología instalada: Node.js"

# Instalar PHP (index.php)
chmod +x /vagrant/scripts/install_php.sh
bash /vagrant/scripts/install_php.sh
msg_success "Tecnología instalada: PHP"

# Instalar Git
chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh

msg_success "El servidor web está listo para usarse: http://localhost:8080/index.html"