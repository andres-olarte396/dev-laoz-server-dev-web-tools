#!/bin/bash

source ./messages.sh

# Actualizamos los paquetes
msg_success "Actualizando paquetes del sistema..."
sudo apt-get update -y && sudo apt-get upgrade -y || { msg_success "Error al actualizar paquetes."; exit 1; }

# Instalamos Java (OpenJDK)
msg_success "Instalando Java (OpenJDK 17)..."
sudo apt-get install -y openjdk-17-jdk || { msg_success "Error al instalar Java."; exit 1; }

# Verificamos la instalación de Java
java_version=$(java -version 2>&1 | head -n 1)
msg_success "Java instalado correctamente: ${java_version}"

# Instalamos Maven
msg_success "Instalando Maven..."
sudo apt-get install -y maven || { msg_success "Error al instalar Maven."; exit 1; }

# Verificamos la instalación de Maven
maven_version=$(mvn -version 2>&1 | head -n 1)
msg_success "Maven instalado correctamente: ${maven_version}"

# Instalamos Spring Boot CLI
msg_success "Instalando Spring Boot CLI..."
SPRING_CLI_VERSION="3.1.5" # Cambia a la versión deseada
wget -q https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/$SPRING_CLI_VERSION/spring-boot-cli-$SPRING_CLI_VERSION-bin.tar.gz -O spring-boot-cli.tar.gz || { msg_success "Error al descargar Spring Boot CLI."; exit 1; }

# Extraemos y configuramos Spring Boot CLI
sudo tar -xzf spring-boot-cli.tar.gz -C /opt/
sudo ln -s /opt/spring-$SPRING_CLI_VERSION/bin/spring /usr/local/bin/spring || { msg_success "Error al configurar Spring Boot CLI."; exit 1; }
rm -f spring-boot-cli.tar.gz

# Verificamos la instalación de Spring Boot CLI
spring_version=$(spring --version 2>/dev/null)
if [ $? -eq 0 ]; then
    msg_success "Spring Boot CLI instalado correctamente: ${spring_version}"
else
    msg_success "Error al instalar Spring Boot CLI."
    exit 1
fi

# Configuración final
msg_success "Instalación completa:"
msg_info " - $java_version"
msg_info " - $maven_version"
msg_info " - $spring_version"
