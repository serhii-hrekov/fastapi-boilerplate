#!/bin/bash

# Configuration for Gunicorn
GUNICORN_WORKERS=4
APP_MODULE="api.index:app"
APP_PORT=8000
# NOTE: The virtual environment activation is NOT needed here because 
# the systemd service file uses 'poetry run'

# Execute Gunicorn. 
exec gunicorn ${APP_MODULE} \
    --workers ${GUNICORN_WORKERS} \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:${APP_PORT} \
    --chdir /path/to/your/app/directory # <-- **REMEMBER TO UPDATE THIS PATH!**