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

for URL in $REPOS; do
    REPO_NAME=$(basename "$URL" .git)
    TARGET_PATH="$BASE_DIR/$REPO_NAME"

    if [ -d "$TARGET_PATH/_" ] || [ -d "$TARGET_PATH/.git" ]; then
        # Check if it's empty (Docker might create empty dir)
        if [ -z "$(ls -A "$TARGET_PATH")" ]; then
             echo "[EMPTY DIR] $REPO_NAME found. Cloning..."
             rmdir "$TARGET_PATH" # Remove empty dir to let git clone work or clone into it .
             git clone "$URL" "$TARGET_PATH"
        else
             echo "[EXISTS] $REPO_NAME"
        fi
    else
        echo "[CLONING] $REPO_NAME from $URL..."
        git clone "$URL" "$TARGET_PATH"
        if [ $? -eq 0 ]; then
             echo "[SUCCESS] $REPO_NAME cloned."
        else
             echo "[ERROR] Failed to clone $REPO_NAME"
        fi
    fi
done

echo "REPO CHECK COMPLETE."
