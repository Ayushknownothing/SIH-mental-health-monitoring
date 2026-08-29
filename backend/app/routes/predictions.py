from fastapi import APIRouter, HTTPException

from app.models.schemas import PredictionCreate
from app.services.prediction_service import (
    create_prediction as create_prediction_service
)

router = APIRouter(
    prefix="/api/predictions",
    tags=["Predictions"]
)


@router.post("/")
def create_prediction(prediction: PredictionCreate):

    try:
        prediction_data = create_prediction_service(
            prediction.interaction_id,
            prediction.distress_score,
            prediction.risk_level,
            prediction.confidence,
            prediction.trend_direction,
            prediction.previous_score,
            prediction.score_change,
            prediction.model_version
        )

        return {
            "message": "Prediction created successfully",
            "prediction": prediction_data
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )