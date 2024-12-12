#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Instalar Git y OpenSSH si no están instalados
apt-get update
apt-get install -y git openssh-client
echo -e "${GREEN}Instalación de Git y OpenSSH completada.${NC}"

# Crear carpeta para claves SSH si no existe
mkdir -p /vagrant/keys

chmod 600 /vagrant/keys/id_ed25519
chmod 600 /vagrant/keys/id_ed25519.pub

# Rutas de las claves SSH
ssh_key="/vagrant/keys/id_ed25519"
ssh_pub_key="/vagrant/keys/id_ed25519.pub"

# Verificar si ya existen las claves SSH
if [ -f "$ssh_key" ] && [ -f "$ssh_pub_key" ]; then
    echo -e "${GREEN}Claves SSH existentes encontradas en $ssh_key.${NC}"
else
    # Generar nuevas claves SSH si no existen
    ssh-keygen -t ed25519 -C "vagrant@local" -f "$ssh_key" -q -N ""
    echo -e "${GREEN}Clave SSH generada correctamente.${NC}"
fi

# Iniciar el agente SSH
echo -e "${GREEN}Iniciando el agente SSH...${NC}"
eval "$(ssh-agent -s)"

# Agregar la clave privada al agente SSH
echo -e "${GREEN}Agregando clave privada al agente${NC}"
ssh-add "$ssh_key" || { echo -e "${RED}Error al agregar la clave SSH al agente.${NC}"; exit 1; }    

# Verificar que la clave está en el agente
if ssh-add -l > /dev/null 2>&1; then
    echo -e "${GREEN}Clave SSH agregada al agente correctamente.${NC}"
else
    echo -e "${RED}Error: No se pudo agregar la clave SSH al agente.${NC}"
    exit 1
fi

# Mostrar la clave pública para que la agregues a GitHub si es nueva
if [ -f "$ssh_pub_key" ]; then
    echo -e "${GREEN}Clave pública generada:${NC}"
    cat "$ssh_pub_key"
    echo -e "${RED}\nSi no lo has hecho, agrega esta clave a tu cuenta de GitHub en https://github.com/settings/keys${NC}"
fi

# Validar autenticación en GitHub
echo -e "${GREEN}Verificando autenticación con GitHub...${NC}"
if git ls-remote git@github.com: > /dev/null 2>&1; then
    echo -e "${GREEN}Autenticación con GitHub verificada correctamente.${NC}"
else
    echo -e "${RED}Error: No se pudo autenticar con GitHub. Asegúrate de haber agregado tu clave SSH a tu cuenta.${NC}"
    # Pausa de 2 minutos para agregar la clave en GitHub
    echo -e "${GREEN}Pausando por 2 minutos para que tengas tiempo de agregar la clave...${NC}"
    sleep 60
fi

# Configurar la lista de hosts conocidos para GitHub
echo -e "${GREEN}Configurando hosts conocidos para GitHub...${NC}"
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

# Crear la carpeta donde se clonarán los proyectos
mkdir -p /var/www/html

# Directorio de origen donde se encuentra el archivo index.html
source_dir="/vagrant"
index_file_source="$source_dir/index.html"

# Directorio de destino donde se moverá el archivo
destination_dir="/var/www/html"
index_file="$destination_dir/index.html"

# Mover el archivo index.html desde el directorio de origen al de destino
if [ -f "$index_file_source" ]; then
    # Si el archivo ya existe en el destino, se elimina
    if [ -f "$index_file" ]; then
        rm -f "$index_file" || { echo -e "${RED}Error al eliminar $index_file"; exit 1; }
    fi

    # Copiar el archivo desde el directorio de origen al destino
    cp "$index_file_source" "$index_file" || { echo -e "${RED}Error al mover $index_file_source a $index_file"; exit 1; }
    echo "Archivo movido desde $source_dir a $destination_dir"
else
    echo -e "${RED}El archivo index.html no existe en el directorio de origen: $source_dir ${NC}"
fi

echo -e "${GREEN}Inicio de la descarga y sincronización de proyectos desde Git ${NC}"

# Archivo que contiene la lista de repositorios (actualiza la ruta aquí)
repos_file="/vagrant/scripts/repos.txt"

# Verificar si el archivo de repositorios existe
if [ ! -f "$repos_file" ]; then
    echo -e "${RED}Error: El archivo $repos_file no existe.${NC}"
    exit 1
fi

# Leer los repositorios del archivo
mapfile -t repos < <(cat "$repos_file" | tr -d '\r' | sed 's/^[ \t]*//;s/[ \t]*$//')

# Rama principal por defecto
main_branch="master"  # Cambia a "main" si es necesario

# Procesar cada repositorio
for repo in "${repos[@]}"; do
    # Continuar si la línea está vacía
    if [[ -z "$repo" ]]; then
        continue
    fi

    repo_name=$(basename "$repo" .git)
    repo_path="/var/www/html/$repo_name"

    echo -e "${GREEN}Procesando el repositorio $repo_name...${NC}"
    
    # Verificar si el repositorio ya está clonado
    if [ -d "$repo_path" ]; then
        echo -e "${RED}El directorio destino $repo_path ya existe. Eliminando...${NC}"
        rm -rf "$repo_path" || { echo -e "${RED}Error al eliminar el directorio $repo_path.${NC}"; exit 1; }
        echo "Directorio eliminado: $repo_path."
    fi

    # Clonar el repositorio usando la clave SSH
    echo "Clonando el repositorio $repo_name..."
    git clone "$repo" "$repo_path" || { echo -e "${RED}Error al clonar el repositorio $repo.${NC}"; exit 1; }

    # Dar permisos de ejecución al script de minificación
    chmod +x /vagrant/scripts/clean_and_minify.sh
    bash /vagrant/scripts/clean_and_minify.sh "$repo_path"

    # Instalar dependencias de Node.js en el proyecto
    if [ -f "$repo_path/package.json" ]; then
        echo -e "${GREEN}Instalando dependencias de Node.js en el proyecto...${NC}"
        cd /vagrant
        npm install || { echo -e "${RED}Error al instalar dependencias del proyecto.${NC}"; exit 1; }
    else
        echo -e "${RED}No se encontró el archivo package.json en $repo_path. Saltando la instalación de dependencias.${NC}"
    fi
done

echo -e "${GREEN}Todos los proyectos se han descargado y configurado correctamente.${NC}"
