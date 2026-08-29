from app.database.supabase_client import supabase


def create_emotion_result(
    interaction_id: str,
    fear: float | None,
    sadness: float | None,
    anger: float | None,
    nervousness: float | None,
    voice_stress: float | None
):
    response = (
        supabase
        .table("emotion_results")
        .insert({
            "interaction_id": interaction_id,
            "fear": fear,
            "sadness": sadness,
            "anger": anger,
            "nervousness": nervousness,
            "voice_stress": voice_stress
        })
        .execute()
    )

    return response.data[0]