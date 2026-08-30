from pathlib import Path
import shutil
import tempfile
from typing import Any

from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from pydantic import BaseModel, Field

from inference.ai_service import process_text, process_audio


app = FastAPI(
    title="SIH Mental Health AI Service",
    version="1.0"
)


class TextRequest(BaseModel):
    text: str

    conversation_history: list[dict[str, Any]] = Field(
        default_factory=list
    )

    previous_distress: float | None = None


@app.get("/")
def root():
    return {
        "service": "SIH Mental Health AI Service",
        "status": "running"
    }


# ============================================================
# TEXT ANALYSIS
# ============================================================

@app.post("/api/analyze/text")
def analyze_text(request: TextRequest):

    try:
        return process_text(
            request.text,
            conversation_history=request.conversation_history,
            previous_distress=request.previous_distress
        )

    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=str(e)
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


# ============================================================
# SPEECH ANALYSIS
# ============================================================

@app.post("/api/analyze/speech")
async def analyze_speech(
    audio: UploadFile = File(...),
    conversation_history: str = Form("[]"),
    previous_distress: float | None = Form(None)
):

    temp_path = None

    try:

        # ----------------------------------------------------
        # Parse conversation history
        # ----------------------------------------------------

        import json

        try:
            history = json.loads(
                conversation_history
            )

        except json.JSONDecodeError:
            raise HTTPException(
                status_code=400,
                detail="Invalid conversation_history JSON"
            )

        if not isinstance(history, list):
            raise HTTPException(
                status_code=400,
                detail="conversation_history must be a list"
            )

        # ----------------------------------------------------
        # Save uploaded audio temporarily
        # ----------------------------------------------------

        suffix = Path(
            audio.filename or ""
        ).suffix

        with tempfile.NamedTemporaryFile(
            delete=False,
            suffix=suffix
        ) as temp_file:

            shutil.copyfileobj(
                audio.file,
                temp_file
            )

            temp_path = temp_file.name

        # ----------------------------------------------------
        # Process audio
        # ----------------------------------------------------

        return process_audio(
            temp_path,
            conversation_history=history,
            previous_distress=previous_distress
        )

    except ValueError as e:

        raise HTTPException(
            status_code=400,
            detail=str(e)
        )

    except HTTPException:

        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )

    finally:

        if temp_path:

            Path(temp_path).unlink(
                missing_ok=True
            )