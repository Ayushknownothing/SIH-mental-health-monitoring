from pathlib import Path
import shutil
import tempfile

from fastapi import FastAPI, File, UploadFile, HTTPException
from pydantic import BaseModel

from inference.ai_service import process_text, process_audio


app = FastAPI(
    title="SIH Mental Health AI Service",
    version="1.0"
)


class TextRequest(BaseModel):
    text: str


@app.get("/")
def root():
    return {
        "service": "SIH Mental Health AI Service",
        "status": "running"
    }


@app.post("/api/analyze/text")
def analyze_text(request: TextRequest):

    try:
        return process_text(request.text)

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


@app.post("/api/analyze/speech")
async def analyze_speech(
    audio: UploadFile = File(...)
):

    temp_path = None

    try:

        suffix = Path(audio.filename or "").suffix

        with tempfile.NamedTemporaryFile(
            delete=False,
            suffix=suffix
        ) as temp_file:

            shutil.copyfileobj(
                audio.file,
                temp_file
            )

            temp_path = temp_file.name

        return process_audio(temp_path)

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

    finally:

        if temp_path:
            Path(temp_path).unlink(
                missing_ok=True
            )