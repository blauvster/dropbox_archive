#!/bin/bash

# Exit on errors
set -e

# Save the original working directory
ORIGINAL_DIR="$(pwd)"

# Get the current directory name
CURRENT_DIR_NAME="$(basename "$ORIGINAL_DIR")"

# Check if the current directory is "linux_scripts"
if [[ "$CURRENT_DIR_NAME" == "linux_scripts" ]]; then
    cd ..
    RETURN_TO_LINUX_SCRIPTS=1
else
    RETURN_TO_LINUX_SCRIPTS=0
fi

# Function to return to the original directory if needed
return_to_original_dir() {
    if [[ $RETURN_TO_LINUX_SCRIPTS -eq 1 ]]; then
        cd "$ORIGINAL_DIR"
    fi
}

# Trap to ensure returning to the original directory on script exit or error
trap return_to_original_dir EXIT

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install Python 3 to proceed."
    exit 1
fi

# Create a virtual environment in the current directory
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Check if requirements.txt exists
if [[ ! -f requirements.txt ]]; then
    echo "requirements.txt file not found in the current directory."
    deactivate
    exit 1
fi

# Install the requirements from requirements.txt
pip install --upgrade pip
pip install -r requirements.txt

echo "Virtual environment setup complete and requirements installed."

# Deactivate the virtual environment
deactivate
