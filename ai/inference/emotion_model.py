import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification


# ============================================================
# CONFIGURATION
# ============================================================

MODEL_NAME = "tabularisai/multilingual-emotion-classification"

LABELS = [
    "anger",
    "contempt",
    "disgust",
    "fear",
    "frustration",
    "gratitude",
    "joy",
    "love",
    "neutral",
    "sadness",
    "surprise"
]

DEVICE = torch.device(
    "cuda" if torch.cuda.is_available() else "cpu"
)


# ============================================================
# MODEL LOADING
# ============================================================

def load_emotion_model():

    print("Loading emotion model...")

    tokenizer = AutoTokenizer.from_pretrained(
        MODEL_NAME
    )

    model = AutoModelForSequenceClassification.from_pretrained(
        MODEL_NAME
    )

    model = model.to(DEVICE)
    model.eval()

    print("Emotion model loaded successfully.")

    return tokenizer, model


# ============================================================
# EMOTION PREDICTION
# ============================================================

def predict_emotion(tokenizer, model, text):

    if not isinstance(text, str):
        raise TypeError("text must be a string")

    text = text.strip()

    if not text:
        raise ValueError("text cannot be empty")

    inputs = tokenizer(
        text,
        return_tensors="pt",
        truncation=True,
        padding=True,
        max_length=192
    )

    inputs = {
        key: value.to(DEVICE)
        for key, value in inputs.items()
    }

    with torch.no_grad():

        outputs = model(**inputs)

    probabilities = torch.sigmoid(
        outputs.logits
    )[0]

    results = {}

    for label, probability in zip(
        LABELS,
        probabilities
    ):

        results[label] = probability.item()

    return results


# ============================================================
# BACKEND-FRIENDLY FUNCTION
# ============================================================

tokenizer, model = load_emotion_model()


def analyze_text(text):

    return predict_emotion(
        tokenizer,
        model,
        text
    )


# ============================================================
# TEST
# ============================================================

if __name__ == "__main__":

    text = "I feel scared and I don't feel safe."

    result = analyze_text(text)

    print("\nText:")
    print(text)

    print("\nEmotion scores:")

    for label, score in result.items():

        print(
            f"{label:15s}: {score:.4f}"
        )