#!/bin/bash
config_file="/vagrant/CONFIGURATION.md"

# Verificar si el archivo de configuración existe
if [[ ! -f "$config_file" ]]; then
    echo "Error: Archivo $config_file no encontrado."
    exit 1
fi

# Procesar según el primer argumento
case $1 in
    tools)
        # Extraer herramientas marcadas
        grep -E '^\- \[x\]' "$config_file" | grep -i -E 'nginx|nodejs|php|spring|dotnet' | awk '{print tolower($NF)}'
        ;;
    repos)
        # Extraer contenido entre paréntesis y separarlo por saltos de línea
        grep -E '^\- \[x\]' "$config_file" | grep -oP '\(.*?\)' | sed 's/[()]//g' | sort -u | tr '\n' '\n'
        ;;
    *)
        echo "Uso: $0 [herramientas|marcados]"
        exit 1
        ;;
esac
