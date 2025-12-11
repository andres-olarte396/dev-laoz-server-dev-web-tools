#!/bin/sh
# Determinar la ubicación del script
SCRIPT_DIR="$( cd "$( dirname "$0" )" > /dev/null 2>&1 && pwd )"
# Por defecto buscar en el directorio padre del script (asumiendo estructura repo/scripts/script.sh)
default_config="$SCRIPT_DIR/../CONFIGURATION.md"
config_file="${2:-$default_config}"

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
        # Debug
        echo "DEBUG: Reading config from $config_file" >&2
        if [ ! -f "$config_file" ]; then echo "DEBUG: File not found!" >&2; fi
        
        # Method using pure awk with CR stripping
        awk '/^- \[x\]/ {print}' "$config_file" | sed 's/\r//g' | awk -F']\\(' '{print $2}' | awk -F')' '{print $1}' | sort -u | tr '\n' ' '
        ;;
    *)
        echo "Uso: $0 [herramientas|marcados]"
        exit 1
        ;;
esac
