import whisper
import torch

AUDIO_PATH = "../data/test_sample3.wav"

print("Loading Whisper...")

device = "cuda" if torch.cuda.is_available() else "cpu"

print("Device:", device)

if device == "cuda":
    print("GPU:", torch.cuda.get_device_name(0))

model = whisper.load_model("small", device=device)

print("\nTranscribing audio...")
result = model.transcribe(
    AUDIO_PATH,
    fp16=(device == "cuda")
)

print("\n" + "=" * 50)
print("WHISPER TRANSCRIPTION")
print("=" * 50)
print(result["text"].strip())
print("=" * 50)