# import io
# import torch
# import torchaudio

# from huggingface_hub import hf_hub_download
# import importlib.util

# MODEL_NAME = "forwarder1121/voice-based-stress-recognition"
# AUDIO_PATH = "../data/test_sample3.wav"


# # --------------------------------------------------
# # Load the custom StudentNet model
# # --------------------------------------------------

# print("Loading voice stress model...")

# models_path = hf_hub_download(
#     repo_id=MODEL_NAME,
#     filename="models.py"
# )

# spec = importlib.util.spec_from_file_location(
#     "voice_models",
#     models_path
# )

# models = importlib.util.module_from_spec(spec)
# spec.loader.exec_module(models)

# StudentForAudioClassification = models.StudentForAudioClassification

# model = StudentForAudioClassification.from_pretrained(
#     MODEL_NAME,
#     trust_remote_code=True
# )


# # --------------------------------------------------
# # Load Wav2Vec2
# # --------------------------------------------------

# print("Loading Wav2Vec2...")

# bundle = torchaudio.pipelines.WAV2VEC2_BASE

# w2v_model = bundle.get_model()


# # --------------------------------------------------
# # Select device
# # --------------------------------------------------

# device = torch.device(
#     "cuda" if torch.cuda.is_available() else "cpu"
# )

# model = model.to(device)
# w2v_model = w2v_model.to(device)

# model.eval()
# w2v_model.eval()

# print("Device:", device)

# if torch.cuda.is_available():
#     print("GPU:", torch.cuda.get_device_name(0))


# # --------------------------------------------------
# # Load audio
# # --------------------------------------------------

# print("\nLoading audio:")

# waveform, orig_sr = torchaudio.load(AUDIO_PATH)

# print("Original sample rate:", orig_sr)
# print("Original shape:", waveform.shape)


# # --------------------------------------------------
# # Convert stereo → mono
# # --------------------------------------------------

# waveform = waveform.mean(dim=0, keepdim=True)


# # --------------------------------------------------
# # Resample → 16 kHz
# # --------------------------------------------------

# if orig_sr != 16000:
#     resampler = torchaudio.transforms.Resample(
#         orig_sr,
#         16000
#     )
#     waveform = resampler(waveform)

# print("Processed shape:", waveform.shape)


# # --------------------------------------------------
# # Move audio to GPU
# # --------------------------------------------------

# waveform = waveform.to(device)


# # --------------------------------------------------
# # Wav2Vec2 → 512-dimensional embedding
# # --------------------------------------------------

# print("\nExtracting Wav2Vec2 features...")

# with torch.no_grad():

#     features = w2v_model(waveform)[0]

#     print("Wav2Vec2 feature shape:", features.shape)

#     x_w2v = features.mean(dim=1)

#     print("After mean pooling:", x_w2v.shape)

#     x_w2v = x_w2v[:, :512]

#     print("Final embedding:", x_w2v.shape)


# # --------------------------------------------------
# # StudentNet → stress probability
# # --------------------------------------------------

# print("\nRunning stress classification...")

# with torch.no_grad():

#     outputs = model(x_w2v)

#     probabilities = torch.softmax(
#         outputs.logits,
#         dim=-1
#     )


# not_stressed = probabilities[0, 0].item()
# stressed = probabilities[0, 1].item()


# # --------------------------------------------------
# # Final result
# # --------------------------------------------------

# print("\n" + "=" * 55)
# print("VOICE STRESS RESULT")
# print("=" * 55)

# print(f"Not stressed : {not_stressed:.4f}")
# print(f"Stressed     : {stressed:.4f}")

# if stressed >= not_stressed:
#     print("Prediction   : STRESSED")
# else:
#     print("Prediction   : NOT STRESSED")

# print("=" * 55)