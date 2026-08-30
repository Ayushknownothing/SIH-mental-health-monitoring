from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from app.services.voice_assessment_service import create_voice_assessment


router = APIRouter(
    prefix="/api/assessments",
    tags=["Voice Assessments"]
)


@router.post("/voice")
async def create_voice_assessment_route(
    victim_id: str = Form(...),
    audio: UploadFile = File(...)
):
    try:
        result = await create_voice_assessment(
            victim_id=victim_id,
            audio=audio
        )

        return {
            "message": "Voice assessment created successfully",
            **result
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )