from pathlib import Path

import torch
import whisper


# ============================================================
# CONFIGURATION
# ============================================================

WHISPER_MODEL = "base"

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"


# ============================================================
# MODEL LOADING
# ============================================================

def load_whisper():

    print("Loading Whisper...")

    model = whisper.load_model(
        WHISPER_MODEL,
        device=DEVICE
    )

    print(f"Whisper device: {DEVICE}")

    return model


# ============================================================
# TRANSCRIPTION
# ============================================================

def transcribe_audio(model, audio_path):

    audio_path = Path(audio_path)

    if not audio_path.exists():
        raise FileNotFoundError(
            f"Audio file not found: {audio_path}"
        )

    result = model.transcribe(
        str(audio_path),
        fp16=(DEVICE == "cuda")
    )

    return result["text"].strip()


# ============================================================
# BACKEND-FRIENDLY FUNCTION
# ============================================================

whisper_model = load_whisper()


def transcribe(audio_path):

    return transcribe_audio(
        whisper_model,
        audio_path
    )


# ============================================================
# TEST
# ============================================================

if __name__ == "__main__":

    PROJECT_ROOT = Path(__file__).resolve().parent.parent

    AUDIO_PATH = (
        PROJECT_ROOT
        / "data"
        / "test_sample.wav"
    )

    print("\nTranscribing audio...")

    text = transcribe(AUDIO_PATH)

    print("\n" + "=" * 60)
    print("TRANSCRIPTION")
    print("=" * 60)
    print(text)
    print("=" * 60)