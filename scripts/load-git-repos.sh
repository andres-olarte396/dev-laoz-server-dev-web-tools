#!/bin/bash
source ./messages.sh

# Instalar Git y OpenSSH si no están instalados
apt-get update
apt-get install -y git openssh-client
msg_success "Instalación de Git y OpenSSH completada."

# Crear carpeta para claves SSH si no existe
mkdir -p /vagrant/keys

chmod 600 /vagrant/keys/id_ed25519
chmod 644 /vagrant/keys/id_ed25519.pub

# Rutas de las claves SSH
ssh_key="/vagrant/keys/id_ed25519"
ssh_pub_key="/vagrant/keys/id_ed25519.pub"

# Verificar si ya existen las claves SSH
if [ -f "$ssh_key" ] && [ -f "$ssh_pub_key" ]; then
    msg_success "Claves SSH existentes encontradas en $ssh_key."
else
    # Generar nuevas claves SSH si no existen
    ssh-keygen -t ed25519 -C "vagrant@local" -f "$ssh_key" -q -N ""
    msg_success "Clave SSH generada correctamente."
fi

# Iniciar el agente SSH
msg_success "Iniciando el agente SSH..."
eval "$(ssh-agent -s)"

# Agregar la clave privada al agente SSH
msg_success "Agregando clave privada al agente"
ssh-add "$ssh_key" || { msg_success "Error al agregar la clave SSH al agente."; exit 1; }    

# Verificar que la clave está en el agente
if ssh-add -l > /dev/null 2>&1; then
    msg_success "Clave SSH agregada al agente correctamente."
else
    msg_success "Error: No se pudo agregar la clave SSH al agente."
    exit 1
fi

# Mostrar la clave pública para que la agregues a GitHub si es nueva
if [ -f "$ssh_pub_key" ]; then
    msg_success "Clave pública generada:"
    cat "$ssh_pub_key"
    msg_success "\nSi no lo has hecho, agrega esta clave a tu cuenta de GitHub en https://github.com/settings/keys"
fi

# Validar autenticación en GitHub
msg_success "Verificando autenticación con GitHub..."
if git ls-remote git@github.com: > /dev/null 2>&1; then
    msg_success "Autenticación con GitHub verificada correctamente."
else
    msg_success "Error: No se pudo autenticar con GitHub. Asegúrate de haber agregado tu clave SSH a tu cuenta."
    # Pausa de 2 minutos para agregar la clave en GitHub
    msg_success "Pausando por 1 minutos para que tengas tiempo de agregar la clave..."
    sleep 60
fi

# Configurar la lista de hosts conocidos para GitHub
msg_success "Configurando hosts conocidos para GitHub..."
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
        rm -f "$index_file" || { msg_success "Error al eliminar $index_file"; exit 1; }
    fi

    # Copiar el archivo desde el directorio de origen al destino
    cp "$index_file_source" "$index_file" || { msg_success "Error al mover $index_file_source a $index_file"; exit 1; }
    msg_info "Archivo movido desde $source_dir a $destination_dir"
else
    msg_success "El archivo index.html no existe en el directorio de origen: $source_dir "
fi

msg_success "Inicio de la descarga y sincronización de proyectos desde Git "

# Archivo que contiene la lista de repositorios (actualiza la ruta aquí)
repos_file="/vagrant/scripts/repos.txt"

# Verificar si el archivo de repositorios existe
if [ ! -f "$repos_file" ]; then
    msg_success "Error: El archivo $repos_file no existe."
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

    # agrega validación de acceso al repositorio GitHub
    if git ls-remote "$repo" > /dev/null 2>&1; then
        msg_success "Acceso al repositorio $repo verificado."
    else
        msg_success "Error: No se pudo acceder al repositorio $repo. Verifica la URL y tu clave SSH."
        continue # Salta al siguiente repositorio
    fi

    repo_name=$(basename "$repo" .git)
    repo_path="/var/www/html/$repo_name"

    msg_success "Procesando el repositorio $repo_name..."
    
    # Verificar si el repositorio ya está clonado
    if [ -d "$repo_path" ]; then
        msg_success "El directorio destino $repo_path ya existe. Eliminando version previa..."
        rm -rf "$repo_path" || { msg_success "Error al eliminar el directorio $repo_path."; exit 1; }
        msg_info "Directorio eliminado: $repo_path."
    fi 

    # Clonar el repositorio usando la clave SSH
    msg_info "Clonando el repositorio $repo_name..."
    git clone "$repo" "$repo_path" || { msg_success "Error al clonar el repositorio $repo."; exit 1; }

    # Dar permisos de ejecución al script de minificación
    chmod +x /vagrant/scripts/clean_and_minify.sh
    bash /vagrant/scripts/clean_and_minify.sh "$repo_path"

    # Instalar dependencias de Node.js en el proyecto
    if [ -f "$repo_path/package.json" ]; then
        msg_success "Instalando dependencias de Node.js en el proyecto..."
        cd "$repo_path"
        npm install || { msg_success "Error al instalar dependencias del proyecto."; exit 1; }
    else
        msg_success "No se encontró el archivo package.json en $repo_path. Saltando la instalación de dependencias."
    fi
done

msg_success "Todos los proyectos se han descargado y configurado correctamente."
