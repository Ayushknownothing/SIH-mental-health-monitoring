# SIH Mental Health AI Service

AI inference service for the SIH Mental Health Monitoring System.

The service supports two types of input:

1. Text input
2. Speech input

For speech input, the audio is first transcribed using Whisper. The resulting text is then passed to the emotion classification model.

The voice-stress classification model is not used in the current pipeline.

---

# 1. Current AI Pipeline

## Text

```text
User Text
    |
    v
Emotion Model
    |
    v
Emotion Scores