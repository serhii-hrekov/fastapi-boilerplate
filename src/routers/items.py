# src/routers/items.py

from fastapi import APIRouter
from pydantic import BaseModel

# --- Pydantic Schema (Model for request/response body) ---
class Item(BaseModel):
    name: str
    price: float
    is_offer: bool | None = None

# Create a new router instance
router = APIRouter()

@router.get("/")
async def read_items():
    """Fetches a list of items."""
    return [{"item_name": "Widget"}, {"item_name": "Doodad"}]

@router.get("/{item_id}")
async def read_item(item_id: int):
    """Fetches a specific item by ID."""
    return {"item_id": item_id, "description": f"This is item #{item_id}"}

@router.post("/")
async def create_item(item: Item):
    """Creates a new item using the Item model for validation."""
    return {"message": "Item successfully created", "item": item}