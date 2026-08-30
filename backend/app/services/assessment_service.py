from app.database.supabase_client import supabase
from app.services.ai_service import analyze_text
from app.services.history_service import (
    get_recent_conversation_history
)


def create_assessment(
    victim_id: str,
    text_response: str | None,
    voice_reference: str | None
):
    emotion_result = None

    # --------------------------------------------------------
    # Get PREVIOUS conversation before saving current message
    # --------------------------------------------------------

    conversation_history = []

    if text_response:

        conversation_history = (
            get_recent_conversation_history(
                victim_id
            )
        )

    # --------------------------------------------------------
    # Analyze current message
    # --------------------------------------------------------

    ai_result = None

    if text_response:

        ai_result = analyze_text(
            text_response,
            conversation_history=conversation_history
        )

    # --------------------------------------------------------
    # Create interaction
    # --------------------------------------------------------

    interaction_response = (
        supabase
        .table("interactions")
        .insert({
            "victim_id": victim_id,
            "text_response": text_response,
            "voice_reference": voice_reference
        })
        .execute()
    )

    interaction = interaction_response.data[0]

    # --------------------------------------------------------
    # Save emotion result
    # --------------------------------------------------------

    if ai_result:

        emotions = ai_result["emotions"]
        explanation = ai_result.get("explanation")

        emotion_response = (
            supabase
            .table("emotion_results")
            .insert({
                "interaction_id": interaction["interaction_id"],
                "input_type": "text",
                "text": text_response,
                "anger": emotions["anger"],
                "contempt": emotions["contempt"],
                "disgust": emotions["disgust"],
                "fear": emotions["fear"],
                "frustration": emotions["frustration"],
                "gratitude": emotions["gratitude"],
                "joy": emotions["joy"],
                "love": emotions["love"],
                "neutral": emotions["neutral"],
                "sadness": emotions["sadness"],
                "surprise": emotions["surprise"]
            })
            .execute()
        )

        emotion_result = emotion_response.data[0]

        if emotion_result:
            emotion_result["explanation"] = explanation

    return {
        "interaction": interaction,
        "emotion_result": emotion_result
    }