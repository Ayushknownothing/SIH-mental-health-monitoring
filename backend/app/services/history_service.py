from app.database.supabase_client import supabase


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