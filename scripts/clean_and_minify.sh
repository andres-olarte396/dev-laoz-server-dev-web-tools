#!/bin/bash

# Definimos colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Directorio predeterminado
DEFAULT_PROJECT_DIR="/var/www/html"

# Asignar el parámetro al directorio del proyecto o usar el valor por defecto
PROJECT_DIR="${1:-$DEFAULT_PROJECT_DIR}"

echo -e "${GREEN}Inicio del proceso de limpieza y minificación de archivos en $PROJECT_DIR.${NC}"

# Verificar si el directorio existe
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: El directorio $PROJECT_DIR no existe."
    exit 1
fi

# Minificar archivos JS
echo "Iniciando minificación de archivos JS del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.js" | while read js_file; do
    uglifyjs "$js_file" -o "${js_file%.js}.js" --compress --mangle
    echo "Minified $js_file -> ${js_file%.js}.js"
done

# Minificar archivos CSS
echo "Iniciando minificación de archivos CSS del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.css" | while read css_file; do
    csso "$css_file" -o "${css_file%.css}.css"
    echo "Minified $css_file -> ${css_file%.css}.css"
done

# Minificar archivos HTML
echo "Iniciando minificación de archivos HTML del directorio: $PROJECT_DIR ..."
find "$PROJECT_DIR" -name "*.html" | while read html_file; do
    html-minifier-terser --collapse-whitespace --remove-comments --remove-optional-tags "$html_file" -o "${html_file%.html}.html"
    echo "Minified $html_file -> ${html_file%.html}.html"
done

echo -e "${GREEN}Todos los archivos del directorio: $PROJECT_DIR se han limpiado y minificado.${NC}"

# Eliminar archivos y carpetas innecesarios
echo "Eliminando archivos y carpetas innecesarios del directorio: $PROJECT_DIR ..."

# Eliminar archivos .gitignore
echo "Eliminando archivos .gitignore..."
find "$PROJECT_DIR" -name "*.gitignore" -type f -exec rm -f {} +

# Eliminar archivos .md
echo "Eliminando archivos .md..."
find "$PROJECT_DIR" -name "*.md" -type f -exec rm -f {} +

# Eliminar la carpeta .git completa
echo "Eliminando carpetas .git..."
find "$PROJECT_DIR" -name ".git" -type d -exec rm -rf {} +

echo "Archivos y carpetas innecesarios eliminados del directorio: $PROJECT_DIR."