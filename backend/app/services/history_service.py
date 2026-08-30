from app.database.supabase_client import supabase


MAX_CONVERSATION_MESSAGES = 6


def get_victim_history(victim_id: str):
    response = (
        supabase
        .table("interactions")
        .select("*, emotion_results(*), predictions(*)")
        .eq("victim_id", victim_id)
        .order("timestamp", desc=True)
        .execute()
    )

    return response.data


def get_recent_conversation_history(victim_id: str):
    response = (
        supabase
        .table("interactions")
        .select("text_response, timestamp")
        .eq("victim_id", victim_id)
        .not_.is_("text_response", "null")
        .order("timestamp", desc=True)
        .limit(MAX_CONVERSATION_MESSAGES)
        .execute()
    )

    messages = []

    for item in reversed(response.data):

        text = item.get("text_response")

        if not text:
            continue

        messages.append({
            "role": "user",
            "content": text
        })

    return messages


def get_previous_distress(victim_id: str):
    response = (
        supabase
        .table("interactions")
        .select(
            "predictions("
            "distress_score,"
            "risk_level,"
            "trend_direction,"
            "previous_score,"
            "score_change,"
            "model_version"
            ")"
        )
        .eq("victim_id", victim_id)
        .order("timestamp", desc=True)
        .limit(1)
        .execute()
    )

    if not response.data:
        return None

    predictions = response.data[0].get("predictions")

    if not predictions:
        return None

    if isinstance(predictions, list):
        if not predictions:
            return None
        prediction = predictions[0]
    else:
        prediction = predictions

    return prediction.get("distress_score")