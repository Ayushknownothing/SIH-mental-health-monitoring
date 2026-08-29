import os

import httpx
from dotenv import load_dotenv


load_dotenv("backend/.env")

AI_SERVICE_URL = os.getenv("AI_SERVICE_URL")


def analyze_text(text: str):
    response = httpx.post(
        f"{AI_SERVICE_URL}/api/analyze/text",
        json={
            "text": text
        },
        timeout=30.0
    )

    response.raise_for_status()

    return response.json()