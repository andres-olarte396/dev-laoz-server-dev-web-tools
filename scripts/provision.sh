#!/bin/bash
source /vagrant/scripts/messages.sh

msg_success " 🎉 Aprovisionando servidor web con herramientas de desarrollo"

# Actualizar sistema
apt-get update -y

# Procesar configuración para herramientas y repositorios
chmod +x /vagrant/scripts/procesar_configuration.sh
herramientas=$(bash /vagrant/scripts/procesar_configuration.sh herramientas)
repositorios=$(bash /vagrant/scripts/procesar_configuration.sh marcados)

msg_info "Herramientas seleccionadas: $herramientas"
msg_info "Repositorios seleccionados: $repositorios"

msg_success " 📝 Configuración procesada desde configuration.md"

# Condiciones para la instalación de herramientas
# if [[ $herramientas == *"nginx"* ]]; then
    chmod +x /vagrant/scripts/install_nginx.sh
    bash /vagrant/scripts/install_nginx.sh
    msg_success " ➕ Tecnología instalada: Nginx"
# fi

# if [[ $herramientas == *"nodejs"* ]]; then
    chmod +x /vagrant/scripts/install_nodejs.sh
    bash /vagrant/scripts/install_nodejs.sh
    msg_success " ➕ Tecnología instalada: Node.js"
# fi

if [[ $herramientas == *"php"* ]]; then
    chmod +x /vagrant/scripts/install_php.sh
    bash /vagrant/scripts/install_php.sh
    msg_success " ➕ Tecnología instalada: PHP"
fi

if [[ $herramientas == *"sprint boot"* ]]; then
    chmod +x /vagrant/scripts/install_sprint_boot.sh
    bash /vagrant/scripts/install_sprint_boot.sh
    msg_success " ➕ Tecnología instalada: Spring Boot"
fi

if [[ $herramientas == *"dotnet"* ]]; then
    chmod +x /vagrant/scripts/install_dotnet_nginx.sh
    bash /vagrant/scripts/install_dotnet_nginx.sh
    msg_success " ➕ Tecnología instalada: dotnet Nginx"
fi

# Puedes agregar más condiciones para otras herramientas
# Por ejemplo, instalación de Spring Boot o .NET si se añaden scripts

# Instalar Git y cargar repositorios seleccionados
chmod +x /vagrant/scripts/load-git-repos.sh
bash /vagrant/scripts/load-git-repos.sh "$repositorios"
msg_success " ➕ Repositorios clonados correctamente"

msg_success " 😃 El servidor web está listo para usarse: http://localhost:8080/index.html"