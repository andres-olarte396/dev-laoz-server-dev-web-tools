#!/bin/bash

echo "Inicio del proceso de limpieza y minificación de archivos."

# Directorio de los proyectos
PROJECT_DIR="/var/www/html"

# Eliminar archivos y carpetas innecesarios
echo "Eliminando archivos y carpetas innecesarios..."
# Eliminar archivos .gitignore
find "$PROJECT_DIR" -name "*.gitignore" -type f -exec rm -f {} +
# Eliminar archivos .md
find "$PROJECT_DIR" -name "*.md" -type f -exec rm -f {} +
# Eliminar archivos previamente minificados
find "$PROJECT_DIR" -name "*.min.*" -type f -exec rm -f {} +
# Eliminar carpeta .git y su contenido
find "$PROJECT_DIR" -name ".git" -type d -exec rm -rf {} +

echo "Archivos y carpetas innecesarios eliminados."

# Minificar archivos JS
echo "Iniciando minificación de archivos JS..."
find "$PROJECT_DIR" -name "*.js" | while read js_file; do
    uglifyjs "$js_file" -o "${js_file%.js}.js" --compress --mangle
    echo "Minified $js_file -> ${js_file%.js}.js"
done

# Minificar archivos CSS
echo "Iniciando minificación de archivos CSS..."
find "$PROJECT_DIR" -name "*.css" | while read css_file; do
    csso "$css_file" -o "${css_file%.css}.css"
    echo "Minified $css_file -> ${css_file%.css}.css"
done

# Minificar archivos HTML
echo "Iniciando minificación de archivos HTML..."
find "$PROJECT_DIR" -name "*.html" | while read html_file; do
    html-minifier-terser --collapse-whitespace --remove-comments --remove-optional-tags "$html_file" -o "${html_file%.html}.html"
    echo "Minified $html_file -> ${html_file%.html}.html"
done

echo "Todos los archivos se han limpiado y minificado."
