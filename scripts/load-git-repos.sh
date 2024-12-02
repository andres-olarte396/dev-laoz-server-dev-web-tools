#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Instalar Git
apt-get install -y git
echo -e "${GREEN}Instalación de git completada.${NC}"

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

# Comprobar si el archivo de repositorios existe
if [ ! -f "$repos_file" ]; then
    echo -e "${RED}Error: El archivo $repos_file no existe."
    exit 1
fi

# Leer los repositorios del archivo, eliminando saltos de línea y espacios en blanco
mapfile -t repos < <(cat "$repos_file" | tr -d '\r' | sed 's/^[ \t]*//;s/[ \t]*$//')

# Rama principal por defecto
main_branch="master"  # Cambia a "main" si es necesario

# Procesar cada repositorio
for repo in "${repos[@]}"; do
    # Continuar si la línea está vacía (por si hay líneas vacías en el archivo)
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

    # Clonar el repositorio
    echo "Clonando el repositorio $repo_name..."
    git clone "$repo" "$repo_path"
    
    # Dar permisos de ejecución al script de minificación
    chmod +x /vagrant/scripts/clean_and_minify.sh
    bash /vagrant/scripts/clean_and_minify.sh "$repo_path"
done

echo -e "${GREEN}Todos los proyectos se han descargado, sincronizado y configurado correctamente.${NC}"
