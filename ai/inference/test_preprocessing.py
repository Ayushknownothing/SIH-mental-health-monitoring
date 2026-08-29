from preprocessing.audio_preprocessor import preprocess_audio


AUDIO_PATH = "data/test_sample.wav"


print("Loading audio...")
waveform, sample_rate = preprocess_audio(AUDIO_PATH)

print("\n" + "=" * 50)
print("AUDIO PREPROCESSING TEST")
print("=" * 50)

print("Shape:", waveform.shape)
print("Sample rate:", sample_rate)
print("Minimum:", waveform.min().item())
print("Maximum:", waveform.max().item())
print("Duration:", waveform.shape[1] / sample_rate, "seconds")

print("=" * 50)