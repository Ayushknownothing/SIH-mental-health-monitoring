from fastapi import APIRouter, HTTPException

from app.models.schemas import VictimCreate
from app.services.victim_service import create_victim as create_victim_service
from app.services.history_service import get_victim_history

router = APIRouter(
    prefix="/api/victims",
    tags=["Victims"]
)


@router.post("/")
def create_victim(victim: VictimCreate):

    try:
        victim_data = create_victim_service(victim.display_name)

        return {
            "message": "Victim created successfully",
            "victim": victim_data
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


@router.get("/{victim_id}/history")
def get_victim_history_endpoint(victim_id: str):

    try:
        history = get_victim_history(victim_id)

        return {
            "victim_id": victim_id,
            "history": history
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )