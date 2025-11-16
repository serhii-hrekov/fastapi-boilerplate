# api/index.py

from fastapi import FastAPI
# 1. Import the configuration settings
from src.config import settings
# 2. Import the modular router
from src.routers.items import router as items_router

# --- FastAPI App Initialization ---
# Optional: Use the app_name from settings
app = FastAPI(title=settings.app_name)

# --- Include Modular Routers ---
# Mount the items_router with a clear prefix like /v1/items
app.include_router(items_router, prefix="/v1/items", tags=["items"])

# --- Root Endpoint (For Vercel/VPS Health Check) ---
@app.get("/")
async def root():
    """A simple root endpoint showing environment variable usage."""
    # Use the loaded settings object
    key_prefix = settings.my_secret_key[:5]
    return {
        "message": f"Welcome to {settings.app_name}!",
        "key_status": f"Secret key starts with: {key_prefix}...",
        "documentation": "/docs"
    }