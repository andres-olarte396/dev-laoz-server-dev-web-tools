#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Actualizamos los paquetes
echo -e "${GREEN}Actualizando paquetes del sistema...${NC}"
sudo apt-get update -y && sudo apt-get upgrade -y || { echo -e "${RED}Error al actualizar paquetes.${NC}"; exit 1; }

# Instalamos Java (OpenJDK)
echo -e "${GREEN}Instalando Java (OpenJDK 17)...${NC}"
sudo apt-get install -y openjdk-17-jdk || { echo -e "${RED}Error al instalar Java.${NC}"; exit 1; }

# Verificamos la instalación de Java
java_version=$(java -version 2>&1 | head -n 1)
echo -e "${GREEN}Java instalado correctamente: ${java_version}${NC}"

# Instalamos Maven
echo -e "${GREEN}Instalando Maven...${NC}"
sudo apt-get install -y maven || { echo -e "${RED}Error al instalar Maven.${NC}"; exit 1; }

# Verificamos la instalación de Maven
maven_version=$(mvn -version 2>&1 | head -n 1)
echo -e "${GREEN}Maven instalado correctamente: ${maven_version}${NC}"

# Instalamos Spring Boot CLI
echo -e "${GREEN}Instalando Spring Boot CLI...${NC}"
SPRING_CLI_VERSION="3.1.5" # Cambia a la versión deseada
wget -q https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/$SPRING_CLI_VERSION/spring-boot-cli-$SPRING_CLI_VERSION-bin.tar.gz -O spring-boot-cli.tar.gz || { echo -e "${RED}Error al descargar Spring Boot CLI.${NC}"; exit 1; }

# Extraemos y configuramos Spring Boot CLI
sudo tar -xzf spring-boot-cli.tar.gz -C /opt/
sudo ln -s /opt/spring-$SPRING_CLI_VERSION/bin/spring /usr/local/bin/spring || { echo -e "${RED}Error al configurar Spring Boot CLI.${NC}"; exit 1; }
rm -f spring-boot-cli.tar.gz

# Verificamos la instalación de Spring Boot CLI
spring_version=$(spring --version 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Spring Boot CLI instalado correctamente: ${spring_version}${NC}"
else
    echo -e "${RED}Error al instalar Spring Boot CLI.${NC}"
    exit 1
fi

# Configuración final
echo -e "${GREEN}Instalación completa:${NC}"
echo " - $java_version"
echo " - $maven_version"
echo " - $spring_version"
