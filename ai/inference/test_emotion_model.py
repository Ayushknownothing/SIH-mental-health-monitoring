import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification

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

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

print("Device:", device)

if torch.cuda.is_available():
    print("GPU:", torch.cuda.get_device_name(0))

print("\nLoading model...")

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)

model = AutoModelForSequenceClassification.from_pretrained(
    MODEL_NAME
)

model.to(device)
model.eval()

print("Model loaded successfully.")


texts = [
    "I am having a normal day and everything is fine.",
    "I feel worried about what is going to happen.",
    "I am scared and I don't feel safe.",
    "I am extremely frightened and I cannot sleep because I keep thinking about what happened.",
    "I am angry that nobody is helping me.",
    "I feel sad and helpless about what happened."
]


for text in texts:

    inputs = tokenizer(
        text,
        return_tensors="pt",
        truncation=True,
        padding=True,
        max_length=192
    )

    inputs = {
        key: value.to(device)
        for key, value in inputs.items()
    }

    with torch.no_grad():
        outputs = model(**inputs)

    probabilities = torch.sigmoid(outputs.logits)[0]

    results = []

    for label, probability in zip(LABELS, probabilities):
        results.append(
            (label, probability.item())
        )

    results.sort(
        key=lambda x: x[1],
        reverse=True
    )

    print("\n" + "=" * 70)
    print("TEXT:", text)
    print("=" * 70)

    for label, probability in results:
        print(f"{label:15s}: {probability:.4f}")