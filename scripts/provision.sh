#!/bin/bash

# Actualizar sistema
apt-get update

bash /vagrant/scripts/install_php.sh
chmod +x /vagrant/scripts/install_php.sh

chmod +x /vagrant/scripts/install_nginx.sh
bash /vagrant/scripts/install_nginx.sh

chmod +x /vagrant/scripts/install_nodejs.sh
bash /vagrant/scripts/install_nodejs.sh

# Ejecutar el script para clonar los repositorios
chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh

echo "El servidor web está listo para usarse: http://localhost:8080/index.html"