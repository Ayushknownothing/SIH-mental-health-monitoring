from app.database.supabase_client import supabase


def create_assessment(
    victim_id: str,
    text_response: str | None,
    voice_reference: str | None
):
    response = (
        supabase
        .table("interactions")
        .insert({
            "victim_id": victim_id,
            "text_response": text_response,
            "voice_reference": voice_reference
        })
        .execute()
    )

    return response.data[0]