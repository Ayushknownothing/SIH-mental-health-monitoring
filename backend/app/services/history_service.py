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


def get_recent_conversation_history(
    victim_id: str,
    limit: int = MAX_CONVERSATION_MESSAGES
):
    """
    Return recent user messages for conversational AI.

    The complete history remains available through
    get_victim_history() for monitoring and prediction.

    Llama only receives the most recent conversation messages.
    """

    history = get_victim_history(victim_id)

    conversation_history = []

    # Supabase returns newest first.
    # Reverse so the conversation is chronological.
    for interaction in reversed(history):

        text = interaction.get("text_response")

        if not text:
            continue

        conversation_history.append({
            "role": "user",
            "content": text
        })

    return conversation_history[-limit:]