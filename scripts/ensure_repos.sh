#!/bin/sh
# ensure_repos.sh
# Check and download repositories defined in CONFIGURATION.md

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
BASE_DIR="${1:-/app/repos}"

# Ensure we are in a directory where we can write if strictly needed, 
# but we clone into BASE_DIR which should be writable.

echo "STARTING REPO CHECK in $BASE_DIR"

if [ ! -d "$BASE_DIR" ]; then
    echo "Creating directory $BASE_DIR..."
    mkdir -p "$BASE_DIR"
fi

# Ensure procesar_configuration is executable
chmod +x "$SCRIPT_DIR/procesar_configuration.sh"

# Get repositories list
REPOS=$("$SCRIPT_DIR/procesar_configuration.sh" repos)

if [ -z "$REPOS" ]; then
    echo "No repositories checked in CONFIGURATION.md or file not found."
    exit 0
fi

echo "Found repositories to check: $REPOS"


# Config output file
NGINX_CONF="/nginx_repos.conf"
echo "# Auto-generated repo locations" > "$NGINX_CONF"

for URL in $REPOS; do
    REPO_NAME=$(basename "$URL" .git)
    FOUND_PATH=""
    
    # Check if repo exists in known subdirectories
    # We check in the order of likelihood or preference
    for SUBDIR in "tools" "core-services" "infrastructure" "education" "dev-laoz-ecosystem" "."; do
        if [ -d "$BASE_DIR/$SUBDIR/$REPO_NAME" ]; then
            # Found it!
            # If SUBDIR is "." (root), path is just REPO_NAME
            if [ "$SUBDIR" = "." ]; then
                FOUND_PATH="$REPO_NAME"
            else
                FOUND_PATH="$SUBDIR/$REPO_NAME"
            fi
            echo "[FOUND] $REPO_NAME in $FOUND_PATH"
            break
        else
            # Debug echo to see what it tried
            # echo "[DEBUG] Not found in $SUBDIR/$REPO_NAME"
            :
        fi
    done

    # If not found, clone it into 'tools' to keep root clean
    if [ -z "$FOUND_PATH" ]; then
        echo "[MISSING] $REPO_NAME. Cloning into tools..."
        TARGET_DIR="$BASE_DIR/tools"
        mkdir -p "$TARGET_DIR"
        
        git clone "$URL" "$TARGET_DIR/$REPO_NAME"
        if [ $? -eq 0 ]; then
             echo "[SUCCESS] $REPO_NAME cloned into tools."
             FOUND_PATH="tools/$REPO_NAME"
        else
             echo "[ERROR] Failed to clone $REPO_NAME"
             continue
        fi
    fi
    
    # Validation
    if [ ! -d "$BASE_DIR/$FOUND_PATH" ]; then
         echo "[WARNING] Path $BASE_DIR/$FOUND_PATH does not exist even after clone/find logic. Skipping config generation for $REPO_NAME."
         continue
    fi
    
    # Generate Nginx location block
    # Note: alias path must end with / if location ends with /
    echo "" >> "$NGINX_CONF"
    echo "location /$REPO_NAME/ {" >> "$NGINX_CONF"
    echo "    alias /var/www/html/$FOUND_PATH/;" >> "$NGINX_CONF"
    echo "    index index.html;" >> "$NGINX_CONF"
    echo "}" >> "$NGINX_CONF"
    
done

echo "REPO CHECK AND CONFIG GENERATION COMPLETE."
