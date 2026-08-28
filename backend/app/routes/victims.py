from fastapi import APIRouter
from app.models.schemas import VictimCreate

router = APIRouter(
    prefix="/api/victims",
    tags=["Victims"]
)


@router.post("/")
def create_victim(victim: VictimCreate):
    return {
        "message": "Victim creation endpoint is working",
        "language": victim.language
    }