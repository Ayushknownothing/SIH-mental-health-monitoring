from fastapi import APIRouter, HTTPException

from app.models.schemas import AssessmentCreate
from app.services.assessment_service import (
    create_assessment as create_assessment_service
)


router = APIRouter(
    prefix="/api/assessments",
    tags=["Assessments"]
)


@router.post("/")
def create_assessment(assessment: AssessmentCreate):

    try:

        result = create_assessment_service(
            assessment.victim_id,
            assessment.text_response,
            assessment.voice_reference
        )

        return {
            "message": "Assessment created successfully",
            "interaction": result["interaction"],
            "emotion_result": result["emotion_result"],
            "prediction": result["prediction"]
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )