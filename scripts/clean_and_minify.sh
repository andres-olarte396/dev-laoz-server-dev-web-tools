#!/bin/bash
source /vagrant/scripts/messages.sh

# Directorio predeterminado
DEFAULT_PROJECT_DIR="/var/www/html"

# Asignar el parámetro al directorio del proyecto o usar el valor por defecto
PROJECT_DIR="${1:-$DEFAULT_PROJECT_DIR}"

msg_success "Inicio del proceso de limpieza y minificación de archivos en $PROJECT_DIR."

# Verificar si el directorio existe
if [ ! -d "$PROJECT_DIR" ]; then
    msg_error "Error: El directorio $PROJECT_DIR no existe."
    exit 1
fi

# Minificar archivos JS
msg_info "Iniciando minificación de archivos JS del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.js" | while read js_file; do
    uglifyjs "$js_file" -o "${js_file%.js}.js" --compress --mangle
    msg_info "Minified $js_file -> ${js_file%.js}.js"
done

# Minificar archivos CSS
msg_info "Iniciando minificación de archivos CSS del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.css" | while read css_file; do
    csso "$css_file" -o "${css_file%.css}.css"
    msg_info "Minified $css_file -> ${css_file%.css}.css"
done

# Minificar archivos HTML
msg_info "Iniciando minificación de archivos HTML del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.html" | while read html_file; do
    html-minifier-terser --collapse-whitespace --remove-comments --remove-optional-tags "$html_file" -o "${html_file%.html}.html"
    msg_info "Minified $html_file -> ${html_file%.html}.html"
done

msg_success "Todos los archivos del directorio: $PROJECT_DIR se han limpiado y minificado."

# Eliminar archivos y carpetas innecesarios
msg_warning "Eliminando archivos y directorios asociados a Git: $PROJECT_DIR ..."

# Eliminar archivos .gitignore
msg_warning "Eliminando archivos .gitignore..."
find "$PROJECT_DIR" -name "*.gitignore" -type f -exec rm -f {} +

# Eliminar la carpeta .git completa
msg_warning "Eliminando directorio .git..."
find "$PROJECT_DIR" -name ".git" -type d -exec rm -rf {} +

msg_info "Archivos y carpetas innecesarios eliminados del directorio: $PROJECT_DIR."
