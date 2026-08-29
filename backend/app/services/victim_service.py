from app.database.supabase_client import supabase


def create_victim(display_name: str | None):
    response = (
        supabase
        .table("victims")
        .insert({
            "display_name": display_name
        })
        .execute()
    )

    return response.data[0]