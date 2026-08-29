import torch
import torchaudio


TARGET_SAMPLE_RATE = 16000


def preprocess_audio(audio_path):
    waveform, sample_rate = torchaudio.load(audio_path)

    # Convert stereo/multi-channel audio to mono
    if waveform.shape[0] > 1:
        waveform = waveform.mean(dim=0, keepdim=True)

    # Resample to 16 kHz
    if sample_rate != TARGET_SAMPLE_RATE:
        resampler = torchaudio.transforms.Resample(
            orig_freq=sample_rate,
            new_freq=TARGET_SAMPLE_RATE
        )
        waveform = resampler(waveform)

    # Normalize amplitude
    max_amplitude = waveform.abs().max()

    if max_amplitude > 0:
        waveform = waveform / max_amplitude

    return waveform, TARGET_SAMPLE_RATE