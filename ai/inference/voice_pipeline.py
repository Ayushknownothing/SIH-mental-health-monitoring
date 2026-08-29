# from pathlib import Path
# import torch
# import torchaudio
# import whisper

# from preprocessing.audio_preprocessor import preprocess_audio
# from models.stress_model import StudentForAudioClassification


# # ============================================================
# # CONFIGURATION
# # ============================================================

# PROJECT_ROOT = Path(__file__).resolve().parent.parent

# AUDIO_PATH = PROJECT_ROOT / "data" / "test_sample4.wav"

# STRESS_MODEL = "forwarder1121/voice-based-stress-recognition"
# WHISPER_MODEL = "base"

# DEVICE = "cuda" if torch.cuda.is_available() else "cpu"


# # ============================================================
# # WHISPER TRANSCRIPTION
# # ============================================================

# def load_whisper():

#     print("Loading Whisper...")

#     model = whisper.load_model(
#         WHISPER_MODEL,
#         device=DEVICE
#     )

#     return model


# def transcribe_audio(model, audio_path):

#     result = model.transcribe(
#         str(audio_path),
#         fp16=(DEVICE == "cuda")
#     )

#     return result["text"].strip()


# # ============================================================
# # WAV2VEC2 EMBEDDING
# # ============================================================

# def load_wav2vec():

#     print("Loading Wav2Vec2...")

#     bundle = torchaudio.pipelines.WAV2VEC2_BASE

#     model = bundle.get_model()

#     model = model.to(DEVICE)

#     model.eval()

#     return model


# def generate_embedding(model, waveform):

#     waveform = waveform.to(DEVICE)

#     with torch.no_grad():

#         features = model(waveform)[0]

#         x_w2v = features.mean(dim=1)

#         x_w2v = x_w2v[:, :512]

#     return x_w2v


# # ============================================================
# # STRESS MODEL
# # ============================================================

# def load_stress_model():

#     print("Loading voice stress model...")

#     model = StudentForAudioClassification.from_pretrained(
#         STRESS_MODEL,
#         trust_remote_code=True
#     )

#     model = model.to(DEVICE)

#     model.eval()

#     return model


# def predict_stress(model, embedding):

#     embedding = embedding.to(DEVICE)

#     with torch.no_grad():

#         outputs = model(embedding)

#         probabilities = torch.softmax(
#             outputs.logits,
#             dim=-1
#         )

#     return probabilities


# # ============================================================
# # MAIN PIPELINE
# # ============================================================

# def main():

#     print("=" * 60)
#     print("VOICE STRESS ANALYSIS")
#     print("=" * 60)

#     print(f"\nAudio file: {AUDIO_PATH}")

#     # --------------------------------------------------------
#     # STEP 1: PREPROCESS AUDIO
#     # --------------------------------------------------------

#     print("\n[1/4] Preprocessing audio...")

#     waveform, sample_rate = preprocess_audio(
#         str(AUDIO_PATH)
#     )

#     duration = waveform.shape[1] / sample_rate

#     print(f"Sample rate : {sample_rate} Hz")
#     print(f"Channels    : {waveform.shape[0]}")
#     print(f"Samples     : {waveform.shape[1]}")
#     print(f"Duration    : {duration:.2f} seconds")

#     # --------------------------------------------------------
#     # STEP 2: TRANSCRIPTION
#     # --------------------------------------------------------

#     print("\n[2/4] Generating transcription...")

#     whisper_model = load_whisper()

#     transcript = transcribe_audio(
#         whisper_model,
#         AUDIO_PATH
#     )

#     print(f"\nTranscript:")
#     print(f'"{transcript}"')

#     # --------------------------------------------------------
#     # STEP 3: WAV2VEC2
#     # --------------------------------------------------------

#     print("\n[3/4] Generating Wav2Vec2 embedding...")

#     wav2vec_model = load_wav2vec()

#     embedding = generate_embedding(
#         wav2vec_model,
#         waveform
#     )

#     print(f"Embedding shape: {embedding.shape}")

#     # --------------------------------------------------------
#     # STEP 4: STRESS CLASSIFICATION
#     # --------------------------------------------------------

#     print("\n[4/4] Running stress classification...")

#     stress_model = load_stress_model()

#     probabilities = predict_stress(
#         stress_model,
#         embedding
#     )

#     not_stressed = probabilities[0][0].item()
#     stressed = probabilities[0][1].item()

#     if stressed >= not_stressed:
#         prediction = "STRESSED"
#         confidence = stressed
#     else:
#         prediction = "NOT STRESSED"
#         confidence = not_stressed

#     # --------------------------------------------------------
#     # FINAL RESULT
#     # --------------------------------------------------------

#     print("\n")
#     print("=" * 60)
#     print("FINAL RESULT")
#     print("=" * 60)

#     print("\nTRANSCRIPTION")
#     print("-" * 60)
#     print(f'"{transcript}"')

#     print("\nSTRESS ANALYSIS")
#     print("-" * 60)

#     print(f"Not stressed : {not_stressed * 100:.2f}%")
#     print(f"Stressed     : {stressed * 100:.2f}%")

#     print(f"\nPrediction   : {prediction}")
#     print(f"Confidence   : {confidence * 100:.2f}%")

#     print("\nSYSTEM")
#     print("-" * 60)

#     print(f"Device       : {DEVICE}")

#     if DEVICE == "cuda":
#         print(f"GPU          : {torch.cuda.get_device_name(0)}")

#     print("=" * 60)


# if __name__ == "__main__":
#     main()