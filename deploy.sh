#!/bin/bash

# --- Configuration ---
PROJECT_NAME="myfastapi"  # Unique name for this service
APP_USER="www-data"      # User to run the service
PROJECT_ROOT=$(pwd)      # Absolute path to the current directory
SERVICE_FILE="/etc/systemd/system/${PROJECT_NAME}.service"
POETRY_BIN=$(which poetry) # Path to the poetry binary

echo "🚀 Starting Poetry-based FastAPI VPS Deployment Setup for $PROJECT_NAME..."

# --- 1. Install Essentials & Poetry ---
echo "📦 Ensuring essential packages and Poetry are installed..."
sudo apt update -y
# Install python-pip and python3-dev (needed to compile some packages)
sudo apt install -y python3-pip python3-dev

# Install Poetry using the recommended method
if ! command -v poetry &> /dev/null; then
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    # Add poetry to the PATH for the current session
    export PATH="$HOME/.local/bin:$PATH"
    POETRY_BIN=$(which poetry)
fi

echo "---"

# --- 2. Install Dependencies via Poetry ---
echo "Installing project dependencies using Poetry..."
# This creates the virtual environment and installs everything from pyproject.toml
$POETRY_BIN install --no-root

# --- 3. Update Gunicorn Starter Path (Same as before, but runs through Poetry) ---
echo "Updating Gunicorn starter script with absolute path..."
# Ensure the gunicorn_starter.sh points to the correct location
sed -i "s|/path/to/your/app/directory|${PROJECT_ROOT}|g" gunicorn_starter.sh
chmod +x gunicorn_starter.sh

# --- 4. Create Systemd Service File ---
echo "Creating systemd service file: ${SERVICE_FILE}"

# Write the systemd unit file content
# **CRUCIAL CHANGE**: ExecStart now uses 'poetry run' to execute the starter script 
# within the Poetry environment.
sudo tee ${SERVICE_FILE} > /dev/null << EOF
[Unit]
Description=Gunicorn instance for ${PROJECT_NAME} (Poetry)
After=network.target

[Service]
User=${APP_USER}
Group=${APP_USER}
WorkingDirectory=${PROJECT_ROOT}
# Use the installed Poetry binary to run the gunicorn_starter.sh script
ExecStart=${POETRY_BIN} run bash ${PROJECT_ROOT}/gunicorn_starter.sh
StandardOutput=journal
StandardError=journal
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# --- 5. Service Management ---
echo "Reloading systemd daemon, enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable ${PROJECT_NAME}.service
sudo systemctl start ${PROJECT_NAME}.service

echo "---"
echo "✅ Poetry-based Deployment complete! Service is running safely."
echo "Status check: sudo systemctl status ${PROJECT_NAME}"