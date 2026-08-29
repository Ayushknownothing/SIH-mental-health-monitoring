from pathlib import Path

from inference.emotion_model import analyze_text
from inference.transcription import transcribe


# ============================================================
# TEXT INPUT
# ============================================================

def process_text(text):

    if not isinstance(text, str):
        raise TypeError("text must be a string")

    text = text.strip()

    if not text:
        raise ValueError("text cannot be empty")

    emotions = analyze_text(text)

    return {
        "input_type": "text",
        "text": text,
        "emotions": emotions
    }


# ============================================================
# SPEECH INPUT
# ============================================================

def process_audio(audio_path):

    audio_path = Path(audio_path)

    if not audio_path.exists():
        raise FileNotFoundError(
            f"Audio file not found: {audio_path}"
        )

    # Step 1: Speech → Text
    text = transcribe(audio_path)

    if not text:
        raise ValueError(
            "Whisper could not extract any text from the audio"
        )

    # Step 2: Text → Emotions
    emotions = analyze_text(text)

    return {
        "input_type": "speech",
        "text": text,
        "emotions": emotions
    }


# ============================================================
# TEST
# ============================================================

if __name__ == "__main__":

    print("=" * 60)
    print("TEXT TEST")
    print("=" * 60)

    text_result = process_text(
        "I feel scared and I don't feel safe."
    )

    print(text_result)


    print("\n" + "=" * 60)
    print("SPEECH TEST")
    print("=" * 60)

    audio_path = (
        Path(__file__).resolve().parent.parent
        / "data"
        / "test_sample.wav"
    )

    audio_result = process_audio(audio_path)

    print(audio_result) 