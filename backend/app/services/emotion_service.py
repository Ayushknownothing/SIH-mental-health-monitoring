from app.database.supabase_client import supabase


def create_emotion_result(
    interaction_id: str,
    input_type: str,
    anger: float | None,
    contempt: float | None,
    disgust: float | None,
    fear: float | None,
    frustration: float | None,
    gratitude: float | None,
    joy: float | None,
    love: float | None,
    neutral: float | None,
    sadness: float | None,
    surprise: float | None
):
    response = (
        supabase
        .table("emotion_results")
        .insert({
            "interaction_id": interaction_id,
            "input_type": input_type,
            "anger": anger,
            "contempt": contempt,
            "disgust": disgust,
            "fear": fear,
            "frustration": frustration,
            "gratitude": gratitude,
            "joy": joy,
            "love": love,
            "neutral": neutral,
            "sadness": sadness,
            "surprise": surprise
        })
        .execute()
    )

    return response.data[0]