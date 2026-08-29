from app.database.supabase_client import supabase


def create_prediction(
    interaction_id: str,
    distress_score: float,
    risk_level: str,
    confidence: float | None,
    trend_direction: str | None,
    previous_score: float | None,
    score_change: float | None,
    model_version: str | None
):
    response = (
        supabase
        .table("predictions")
        .insert({
            "interaction_id": interaction_id,
            "distress_score": distress_score,
            "risk_level": risk_level,
            "confidence": confidence,
            "trend_direction": trend_direction,
            "previous_score": previous_score,
            "score_change": score_change,
            "model_version": model_version
        })
        .execute()
    )

    return response.data[0]