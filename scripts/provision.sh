#!/bin/bash

# Actualizar sistema
apt-get update

chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh

echo "El servidor web está listo para usarse: http://localhost:8080/index.html"