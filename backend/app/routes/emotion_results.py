from fastapi import APIRouter, HTTPException

from app.models.schemas import EmotionResultCreate
from app.services.emotion_service import (
    create_emotion_result as create_emotion_result_service
)

router = APIRouter(
    prefix="/api/emotion-results",
    tags=["Emotion Results"]
)


@router.post("/")
def create_emotion_result(result: EmotionResultCreate):

    try:
        emotion_data = create_emotion_result_service(
            result.interaction_id,
            result.input_type,
            result.anger,
            result.contempt,
            result.disgust,
            result.fear,
            result.frustration,
            result.gratitude,
            result.joy,
            result.love,
            result.neutral,
            result.sadness,
            result.surprise
        )

        return {
            "message": "Emotion result created successfully",
            "emotion_result": emotion_data
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )