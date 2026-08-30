import json
import os
import subprocess
import tempfile

import httpx
from fastapi import UploadFile

from app.database.supabase_client import supabase
from app.services.history_service import (
    get_recent_conversation_history,
    get_previous_distress
)


AI_SERVICE_URL = os.getenv("AI_SERVICE_URL")


async def create_voice_assessment(
    victim_id: str,
    audio: UploadFile
):
    # --------------------------------------------------------
    # Read uploaded audio
    # --------------------------------------------------------

    audio_bytes = await audio.read()

    if not audio_bytes:
        raise ValueError(
            "Audio file cannot be empty"
        )

    original_filename = (
        audio.filename or "audio"
    )

    original_extension = os.path.splitext(
        original_filename
    )[1].lower()

    # --------------------------------------------------------
    # Convert audio to WAV when necessary
    # --------------------------------------------------------

    converted_audio_path = None

    try:

        if original_extension == ".wav":

            processed_audio_bytes = audio_bytes
            processed_filename = original_filename
            processed_content_type = "audio/wav"

        else:

            with tempfile.NamedTemporaryFile(
                delete=False,
                suffix=original_extension or ".audio"
            ) as input_file:

                input_file.write(audio_bytes)
                input_audio_path = input_file.name

            converted_audio_path = (
                input_audio_path + ".wav"
            )

            try:

                subprocess.run(
                    [
                        "ffmpeg",
                        "-y",
                        "-i",
                        input_audio_path,
                        "-ar",
                        "16000",
                        "-ac",
                        "1",
                        converted_audio_path
                    ],
                    check=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE
                )

            except subprocess.CalledProcessError as e:

                error_message = (
                    e.stderr.decode(
                        errors="ignore"
                    )
                )

                raise ValueError(
                    f"Audio conversion failed: "
                    f"{error_message}"
                )

            with open(
                converted_audio_path,
                "rb"
            ) as converted_file:

                processed_audio_bytes = (
                    converted_file.read()
                )

            processed_filename = (
                os.path.splitext(
                    original_filename
                )[0]
                + ".wav"
            )

            processed_content_type = "audio/wav"

    finally:

        if (
            "input_audio_path" in locals()
            and os.path.exists(input_audio_path)
        ):
            os.remove(input_audio_path)

        if (
            converted_audio_path is not None
            and os.path.exists(converted_audio_path)
        ):
            os.remove(converted_audio_path)

    # --------------------------------------------------------
    # Get previous conversation and distress
    # BEFORE processing current voice message
    # --------------------------------------------------------

    conversation_history = (
        get_recent_conversation_history(
            victim_id
        )
    )

    previous_distress = (
        get_previous_distress(
            victim_id
        )
    )

    # --------------------------------------------------------
    # Prepare processed WAV audio
    # --------------------------------------------------------

    files = {
        "audio": (
            processed_filename,
            processed_audio_bytes,
            processed_content_type
        )
    }

    data = {
        "conversation_history": json.dumps(
            conversation_history
        ),
        "previous_distress": (
            str(previous_distress)
            if previous_distress is not None
            else ""
        )
    }

    # --------------------------------------------------------
    # Send WAV audio to AI service
    # --------------------------------------------------------

    async with httpx.AsyncClient(
        timeout=120.0
    ) as client:

        response = await client.post(
            f"{AI_SERVICE_URL}/api/analyze/speech",
            files=files,
            data=data
        )

    response.raise_for_status()

    ai_result = response.json()

    # --------------------------------------------------------
    # Create interaction
    # --------------------------------------------------------

    interaction_response = (
        supabase
        .table("interactions")
        .insert({
            "victim_id": victim_id,
            "text_response": ai_result["text"],
            "voice_reference": original_filename
        })
        .execute()
    )

    interaction = interaction_response.data[0]

    # --------------------------------------------------------
    # Get emotion, distress and explanation results
    # --------------------------------------------------------

    emotions = ai_result["emotions"]
    distress = ai_result.get("distress")
    explanation = ai_result.get("explanation")

    # --------------------------------------------------------
    # Save emotion result
    # --------------------------------------------------------

    emotion_response = (
        supabase
        .table("emotion_results")
        .insert({
            "interaction_id": interaction["interaction_id"],
            "input_type": "voice",
            "text": ai_result["text"],
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

    # --------------------------------------------------------
    # Save distress prediction
    # --------------------------------------------------------

    prediction_result = None

    if distress:

        prediction_response = (
            supabase
            .table("predictions")
            .insert({
                "interaction_id": interaction["interaction_id"],
                "distress_score": distress["distress_score"],
                "risk_level": distress["risk_level"],
                "confidence": distress.get("confidence"),
                "trend_direction": distress["trend_direction"],
                "previous_score": distress["previous_score"],
                "score_change": distress["score_change"],
                "model_version": distress.get(
                    "model_version"
                )
            })
            .execute()
        )

        prediction_result = prediction_response.data[0]

    # --------------------------------------------------------
    # Return complete voice assessment
    # --------------------------------------------------------

    return {
        "interaction": interaction,
        "emotion_result": emotion_result,
        "prediction": prediction_result
    }