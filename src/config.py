# src/config.py

from pydantic_settings import BaseSettings, SettingsConfigDict
from dotenv import load_dotenv

# Load environment variables from .env file (for local development)
load_dotenv()

class Settings(BaseSettings):
    """
    Configuration settings for the application.
    Fields correspond to environment variables (e.g., MY_SECRET_KEY).
    """
    # The Vercel runtime is based on pydantic-settings, 
    # so we explicitly tell it to load from .env file locally.
    model_config = SettingsConfigDict(env_file='.env', extra='ignore')
    
    # Required variable (no default provided)
    app_name: str = "Modular FastAPI App"
    
    # Example environment variable
    my_secret_key: str 

# Create a singleton instance of the settings
settings = Settings()