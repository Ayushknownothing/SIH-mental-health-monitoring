from pathlib import Path

from inference.emotion_model import analyze_text
from inference.transcription import transcribe
from inference.distress_predictor import predict_distress
from inference.llama_service import generate_explanation


# ============================================================
# TEXT INPUT
# ============================================================

def process_text(
    text,
    conversation_history=None,
    previous_distress=None
):
    """
    Process a text message.

    Flow:
        User message
            ↓
        Emotion Model
            ↓
        Emotion scores
            ↓
        Distress Predictor
            ↓
        Distress score + risk level
            ↓
        Llama + conversation history
            ↓
        Conversational response
    """

    if not isinstance(text, str):
        raise TypeError("text must be a string")

    text = text.strip()

    if not text:
        raise ValueError("text cannot be empty")

    if conversation_history is None:
        conversation_history = []

    # Step 1: Text → Emotions
    emotions = analyze_text(text)

    # Step 2: Emotions → Distress Prediction
    distress = predict_distress(
        emotions,
        previous_distress=previous_distress
    )

    # Step 3: Current message + emotions + distress
    #         + conversation history → Llama
    explanation = generate_explanation(
        current_message=text,
        emotions=emotions,
        distress_score=distress["distress_score"],
        risk_level=distress["risk_level"],
        conversation_history=conversation_history
    )

    # Step 4: Return combined result
    return {
        "input_type": "text",
        "text": text,
        "emotions": emotions,
        "distress": distress,
        "explanation": explanation
    }


# ============================================================
# SPEECH INPUT
# ============================================================

def process_audio(
    audio_path,
    conversation_history=None,
    previous_distress=None
):
    """
    Process a voice message.

    Flow:
        Audio
            ↓
        Whisper
            ↓
        Text
            ↓
        Emotion Model
            ↓
        Distress Predictor
            ↓
        Distress score + risk level
            ↓
        Llama + conversation history
            ↓
        Conversational response
    """

    audio_path = Path(audio_path)

    if not audio_path.exists():
        raise FileNotFoundError(
            f"Audio file not found: {audio_path}"
        )

    if conversation_history is None:
        conversation_history = []

    # Step 1: Speech → Text
    text = transcribe(audio_path)

    if not text:
        raise ValueError(
            "Whisper could not extract any text from the audio"
        )

    # Step 2: Text → Emotions
    emotions = analyze_text(text)

    # Step 3: Emotions → Distress Prediction
    distress = predict_distress(
        emotions,
        previous_distress=previous_distress
    )

    # Step 4: Transcript + emotions + distress
    #         + history → Llama
    explanation = generate_explanation(
        current_message=text,
        emotions=emotions,
        distress_score=distress["distress_score"],
        risk_level=distress["risk_level"],
        conversation_history=conversation_history
    )

    # Step 5: Return combined result
    return {
        "input_type": "speech",
        "text": text,
        "emotions": emotions,
        "distress": distress,
        "explanation": explanation
    }


# ============================================================
# TEST
# ============================================================

if __name__ == "__main__":

    print("=" * 60)
    print("TEXT TEST")
    print("=" * 60)

    text_result = process_text(
        "I feel completely overwhelmed and terrified. "
        "I cannot cope with everything anymore."
    )

    print(text_result)

    print("\n" + "=" * 60)
    print("TEXT TEST WITH PREVIOUS DISTRESS")
    print("=" * 60)

    text_result = process_text(
        "I have been feeling less worried today.",
        previous_distress=73.59
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