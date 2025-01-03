#!/bin/bash
source /vagrant/scripts/messages.sh

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
ssh-add "$ssh_key" || { msg_error "Error al agregar la clave SSH al agente."; exit 1; }

# Verificar que la clave está en el agente
if ssh-add -l > /dev/null 2>&1; then
    msg_success "Clave SSH agregada al agente correctamente."
else
    msg_error "Error: No se pudo agregar la clave SSH al agente."
    exit 1
fi

# Mostrar la clave pública para que la agregues a GitHub si es nueva
if [ -f "$ssh_pub_key" ]; then
    msg_success "Clave pública generada:"
    cat "$ssh_pub_key"
    msg_info "Si no lo has hecho, agrega esta clave a tu cuenta de GitHub en https://github.com/settings/keys"
fi

# Validar autenticación en GitHub
msg_success "Verificando autenticación con GitHub..."
if git ls-remote git@github.com: > /dev/null 2>&1; then
    msg_success "Autenticación con GitHub verificada correctamente."
else
    msg_error "Error: No se pudo autenticar con GitHub. Asegúrate de haber agregado tu clave SSH a tu cuenta."
    # Pausa de 1 minutos para agregar la clave en GitHub
    msg_warning "Pausando por 1 minutos para que tengas tiempo de agregar la clave..."
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
        rm -f "$index_file" || { msg_error "Error al eliminar $index_file"; exit 1; }
    fi

    # Copiar el archivo desde el directorio de origen al destino
    cp "$index_file_source" "$index_file" || { msg_error "Error al mover $index_file_source a $index_file"; exit 1; }
    msg_info "Archivo movido desde $source_dir a $destination_dir"
else
    msg_error "El archivo index.html no existe en el directorio de origen: $source_dir "
fi

# Validar que se hayan pasado argumentos
if [ "$#" -eq 0 ]; then
    msg_error "Error: No se proporcionaron URLs de repositorios."
    exit 1
fi

msg_info "Inicio de la descarga y configuración de proyectos..."

# Rama principal por defecto
main_branch="master"  # Cambiar a "main" si es necesario

# Procesar los argumentos (URLs) y separar por saltos de línea
repos=$(echo "$@" | sed 's/default: /\n/g')

# Procesar cada URL de repositorio pasado como argumento
for repo in $repos; do
    # Continuar si la URL está vacía
    if [[ -z "$repo" ]]; then
        continue
    fi

    # Validar acceso al repositorio
    if git ls-remote "$repo" > /dev/null 2>&1; then
        msg_success "Acceso al repositorio $repo verificado."
    else
        msg_error "Error: No se pudo acceder al repositorio $repo. Verifica la URL y tu clave SSH."
        continue # Saltar al siguiente repositorio
    fi

    repo_name=$(basename "$repo" .git)
    repo_path="/var/www/html/$repo_name"

    msg_info "Procesando el repositorio $repo_name..."

    # Verificar si el repositorio ya está clonado
    if [ -d "$repo_path" ]; then
        msg_warning "El directorio destino $repo_path ya existe. Eliminando versión previa..."
        rm -rf "$repo_path" || { msg_error "Error al eliminar el directorio $repo_path."; exit 1; }
        msg_warning "Directorio eliminado: $repo_path."
    fi 

    # Clonar el repositorio usando la clave SSH
    msg_info "Clonando el repositorio $repo_name..."
    git clone "$repo" "$repo_path" || { msg_error "Error al clonar el repositorio $repo."; exit 1; }

    # Dar permisos de ejecución al script de minificación
    chmod +x /vagrant/scripts/clean_and_minify.sh
    bash /vagrant/scripts/clean_and_minify.sh "$repo_path"

    # Instalar dependencias de Node.js en el proyecto en un nuevo hilo
    if [ -f "$repo_path/package.json" ]; then
        msg_info "Instalando dependencias de Node.js en el proyecto en segundo plano..."
        (
            cd "$repo_path" || { msg_error "Error al cambiar al directorio $repo_path."; exit 1; }
            npm install && npm start
            if [ $? -eq 0 ]; then
                msg_success "El proyecto en $repo_path inició correctamente."
            else
                msg_error "Error al iniciar el proyecto en $repo_path."
            fi
        ) &
        msg_info "La instalación y ejecución del proyecto Node.js continúa en segundo plano."
    fi
done

msg_success "Todos los proyectos se han descargado y configurado correctamente."
