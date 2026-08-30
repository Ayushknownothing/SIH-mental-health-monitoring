# SIH Mental Health Monitoring — Backend

## 1. Overview

This directory contains the FastAPI backend for the AI-based Dynamic Mental Health Monitoring System.

The backend is responsible for:

- Managing victims
- Creating text assessments
- Creating voice assessments
- Communicating with the AI service
- Managing recent conversation context
- Retrieving previous distress scores
- Storing interaction and emotion results in Supabase
- Storing calibrated distress predictions in Supabase
- Providing APIs for emotion results and distress predictions
- Providing victim history for dynamic monitoring
- Returning AI-generated explanations from the local Llama/Ollama layer
- Converting uploaded/recorded audio to WAV using FFmpeg before AI processing

The backend connects the frontend, AI services/models, and Supabase database.

---

# 2. Current Architecture

## Text Assessment

```text
Frontend / Client
       |
       | POST /api/assessments/
       v
FastAPI Backend :8000
       |
       +----------------------------+
       |                            |
       v                            v
Recent Conversation History     Previous Distress
       |                            |
       +-------------+--------------+
                     |
                     v
                Current Text
                     |
                     v
               AI Service :8001
                     |
                     v
              Emotion Model 1
                     |
                     v
              Emotion Scores
                     |
                     v
       Model 3 — Calibrated Distress
                     |
              +------+------+
              |             |
              v             v
       Distress Score    Trend Analysis
              |
              v
        Ollama :11434
              |
              v
         Llama 3.2:3b
              |
              v
      Conversational /
     Supportive Explanation
              |
              v
        Backend Response
          /          \
         v            v
    Supabase       Frontend
```

---

## Voice Assessment

The frontend may provide voice input either by:

- Recording audio directly
- Uploading an existing audio file

The backend accepts the audio input and converts it to WAV format using FFmpeg before sending it to the AI service.

```text
Frontend / Client
       |
       | POST /api/assessments/voice
       v
FastAPI Backend :8000
       |
       +----------------------------+
       |                            |
       v                            v
Recent Conversation History     Previous Distress
       |                            |
       +-------------+--------------+
                     |
                     v
                Current Audio
                     |
                     v
            FFmpeg Audio Conversion
                     |
                     v
                  WAV Audio
                     |
                     v
               AI Service :8001
                     |
                     v
                   Whisper
                     |
                     v
             Transcribed Text
                     |
                     v
              Emotion Model 1
                     |
                     v
       Model 3 — Calibrated Distress
                     |
              +------+------+
              |             |
              v             v
       Distress Score    Trend Analysis
              |
              v
        Ollama :11434
              |
              v
         Llama 3.2:3b
              |
              v
      Conversational /
     Supportive Explanation
              |
              v
        Backend Response
          /          \
         v            v
    Supabase       Frontend
```

---

# 3. Technology Stack

- Python
- FastAPI
- Uvicorn
- Pydantic
- Supabase
- PostgreSQL through Supabase
- HTTPX
- python-multipart for voice uploads
- FFmpeg for audio format conversion
- Whisper for speech-to-text
- Hugging Face Transformers for Emotion Model 1
- Ollama for local Llama inference
- Llama 3.2:3b
- Scikit-learn
- Pandas
- Joblib
- Separate AI service on port 8001

---

# 4. Project Structure

```text
SIH-mental-health-monitoring/
|
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── database/
│   │   │   ├── supabase_client.py
│   │   │   └── __init__.py
│   │   ├── models/
│   │   │   ├── schemas.py
│   │   │   └── __init__.py
│   │   ├── routes/
│   │   │   ├── victims.py
│   │   │   ├── assessments.py
│   │   │   ├── voice_assessments.py
│   │   │   ├── emotion_results.py
│   │   │   ├── predictions.py
│   │   │   └── __init__.py
│   │   └── services/
│   │       ├── victim_service.py
│   │       ├── assessment_service.py
│   │       ├── voice_assessment_service.py
│   │       ├── emotion_service.py
│   │       ├── history_service.py
│   │       ├── prediction_service.py
│   │       ├── ai_service.py
│   │       └── __init__.py
│   ├── requirements.txt
│   ├── .env
│   ├── .gitignore
│   └── README.md
|
├── ai/
│   ├── inference/
│   │   ├── ai_service.py
│   │   ├── emotion_model.py
│   │   ├── distress_predictor.py
│   │   ├── llama_service.py
│   │   └── transcription.py
│   ├── training/
│   │   ├── calibrated_distress_model.pkl
│   │   └── train_calibrated_model.py
│   ├── api.py
│   ├── test_api.py
│   ├── requirements.txt
│   ├── README.md
│   └── venv/
|
└── ...
```

`venv/`, `__pycache__/`, and `.pyc` files are generated/local files and should not be committed.

---

# 5. Environment Configuration

The backend uses:

```text
backend/.env
```

Expected variables:

```env
SUPABASE_URL=<your-supabase-url>
SUPABASE_KEY=<your-supabase-key>

AI_SERVICE_URL=http://127.0.0.1:8001
```

The AI service uses:

```env
LLAMA_BASE_URL=http://127.0.0.1:11434
LLAMA_MODEL=llama3.2:3b
```

Never commit `.env` files or secret keys to GitHub.

---

# 6. Python Environment Setup

## Backend

From the repository root:

```powershell
cd backend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

If the virtual environment does not exist:

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

---

## AI Service

```powershell
cd ai
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

The AI service environment contains the required packages for Transformers, PyTorch, Whisper, FastAPI, scikit-learn, pandas, joblib, and related inference dependencies.

---

# 7. Running the System Locally

The local system uses three services/components:

- AI Service
- Backend
- Ollama

---

## Terminal 1 — AI Service

```powershell
cd ai
.\venv\Scripts\Activate.ps1
python -m uvicorn api:app --reload --port 8001
```

AI service:

```text
http://127.0.0.1:8001
```

---

## Terminal 2 — Backend

```powershell
cd backend
.\venv\Scripts\Activate.ps1
python -m uvicorn app.main:app --reload --port 8000
```

Backend:

```text
http://127.0.0.1:8000
```

---

## Ollama

Ollama runs locally as a separate background service:

```text
http://127.0.0.1:11434
```

Current model:

```text
llama3.2:3b
```

Check installed models:

```powershell
ollama list
```

Check Ollama API:

```powershell
Invoke-RestMethod http://127.0.0.1:11434/api/tags
```

Ollama is a separate local service. It is not started by FastAPI.

---

# Local Service Layout

```text
Terminal 1
    AI Service :8001

Terminal 2
    Backend :8000

Ollama
    Local background service :11434
```

---

# 8. Backend API

## Root

```text
GET /
```

## Health

```text
GET /health
```

## Victims

```text
POST /api/victims/
```

```text
GET /api/victims/{victim_id}/history
```

---

# Text Assessment

```text
POST /api/assessments/
```

Example request:

```json
{
    "victim_id": "<victim-id>",
    "text_response": "I feel very scared and stressed",
    "voice_reference": null
}
```

The backend:

1. Retrieves recent conversation history for the victim.
2. Retrieves the previous distress score.
3. Sends the current text, conversation history, and previous distress to the AI service.
4. Receives emotion results.
5. Receives the calibrated distress prediction.
6. Receives the Llama explanation.
7. Creates the interaction in Supabase.
8. Stores the emotion result in Supabase.
9. Stores the distress prediction in the `predictions` table.
10. Returns the interaction, emotion result, and prediction to the client.

---

# Voice Assessment

```text
POST /api/assessments/voice
```

Multipart form:

```text
victim_id = <victim-id>
audio = <audio-file>
```

The frontend may provide either a recorded audio file or an uploaded audio file.

The backend accepts the supplied audio format and converts it to WAV using FFmpeg before sending it to the AI service.

Supported input examples include:

```text
.wav
.ogg
.webm
.mp3
.m4a
```

The exact browser recording format depends on the frontend/device.

## Voice Processing Flow

```text
Recorded / Uploaded Audio
          |
          v
     Backend :8000
          |
          v
   FFmpeg Conversion
          |
          v
       WAV Audio
          |
          v
     AI Service :8001
          |
          v
        Whisper
          |
          v
   Transcribed Text
          |
          v
    Emotion Model 1
          |
          v
    Model 3 Distress
          |
          v
       Llama
          |
          v
       Backend
          |
          v
       Supabase
```

The backend:

1. Reads the uploaded/recorded audio.
2. Validates that the audio is not empty.
3. Retrieves recent conversation history for the victim.
4. Retrieves the previous distress score.
5. Converts the audio to WAV format using FFmpeg.
6. Sends the converted WAV audio, conversation history, and previous distress score to the AI service.
7. The AI service transcribes the WAV audio using Whisper.
8. The transcribed text is analyzed by Emotion Model 1.
9. Model 3 generates the distress prediction and trend.
10. Llama generates the conversational explanation.
11. The backend creates the interaction in Supabase.
12. The backend stores the emotion result.
13. The backend stores the distress prediction.
14. The result is returned to the client.

The uploaded filename is stored as `voice_reference`.

---

# 9. AI Service

The AI service is a separate FastAPI application.

Location:

```text
ai/
```

Main API:

```text
ai/api.py
```

Endpoints:

```text
POST /api/analyze/text
POST /api/analyze/speech
```

---

## Text

```text
Text
  ↓
Recent Conversation History
  ↓
Emotion Model 1
  ↓
Emotion Scores
  ↓
Model 3 — Calibrated Distress Prediction
  ↓
Distress Score + Risk + Trend
  ↓
Llama 3.2:3b through Ollama
  ↓
Supportive / Conversational Explanation
  ↓
AI Service Response
```

---

## Speech

```text
Audio
  ↓
WAV Audio
  ↓
Whisper
  ↓
Transcribed Text
  ↓
Recent Conversation History
  ↓
Emotion Model 1
  ↓
Model 3 — Calibrated Distress Prediction
  ↓
Distress Score + Risk + Trend
  ↓
Llama 3.2:3b through Ollama
  ↓
Supportive / Conversational Explanation
  ↓
AI Service Response
```

---

# 10. Emotion Model 1

Emotion Model 1 produces:

```text
anger
contempt
disgust
fear
frustration
gratitude
joy
love
neutral
sadness
surprise
```

The backend stores these values in the `emotion_results` table.

Status:

```text
IMPLEMENTED AND TESTED
```

Both text and voice emotion flows have been tested successfully.

---

# 11. Whisper Speech-to-Text

Voice processing uses OpenAI Whisper.

The speech-to-text pipeline is:

```text
Recorded / Uploaded Audio
        ↓
Backend FFmpeg Conversion
        ↓
WAV Audio
        ↓
Whisper
        ↓
Text Transcription
```

The transcribed text is then passed to Emotion Model 1, Model 3, and the Llama conversational layer.

Whisper currently runs on CPU in the local setup.

---

## FFmpeg Requirement

FFmpeg must be installed and available in the system PATH.

Check installation:

```powershell
ffmpeg -version
```

FFmpeg is used by the backend to normalize recorded or uploaded audio into WAV format before sending it to the AI service.

This allows the frontend to provide common browser/recorder audio formats without requiring the user to manually convert the file.

Example:

```text
Browser Recording
       |
       v
OGG / WebM / Other Supported Format
       |
       v
Backend
       |
       v
FFmpeg
       |
       v
WAV
       |
       v
Whisper
```

---

# 12. Llama / Ollama Integration

Llama is implemented as the conversational/explanation layer.

Ollama:

```text
http://127.0.0.1:11434
```

Model:

```text
llama3.2:3b
```

AI service implementation:

```text
ai/inference/llama_service.py
```

## Role of Llama

Llama is responsible for:

- Explaining emotion results
- Producing human-readable responses
- Providing supportive language
- Maintaining conversational continuity using supplied recent history
- Asking relevant follow-up questions
- Keeping explanations non-diagnostic
- Explaining supplied model outputs without replacing the ML models

## Llama must not:

- Diagnose a mental health condition
- Invent distress scores
- Calculate the core distress prediction
- Change a risk level generated by Model 3
- Replace the ML prediction models

The numerical prediction comes from the defined ML pipeline.

---

# 13. Conversational Context

For each new assessment, the backend retrieves the victim's previous interaction history from Supabase.

The complete interaction history remains stored in Supabase.

Recent history is supplied to the AI service as conversational context.

The history service is:

```text
backend/app/services/history_service.py
```

The relevant function is:

```text
get_recent_conversation_history(victim_id)
```

Previous distress is retrieved separately using:

```text
get_previous_distress(victim_id)
```

Text requests send:

```text
text
conversation_history
previous_distress
```

Voice requests send:

```text
audio
conversation_history
previous_distress
```

Conversation history does not replace the emotion model.

Conversation history does not replace Model 3.

The complete history remains available through:

```text
GET /api/victims/{victim_id}/history
```

---

## Text Conversation Flow

```text
Previous interactions
        |
        v
Recent conversation history
        |
        +-----------------------+
        |                       |
        v                       v
Current text            Emotion Model 1
        |                       |
        +-----------+-----------+
                    |
                    v
              Model 3 Distress
                    |
                    v
                  Llama
                    |
                    v
           Conversational response
```

---

## Voice Conversation Flow

```text
Previous interactions
        |
        v
Recent conversation history
        |
        +-----------------------+
        |                       |
        v                       v
Current audio             FFmpeg
                              |
                              v
                           WAV Audio
                              |
                              v
                           Whisper
                              |
                              v
                       Transcribed text
                              |
                              v
                       Emotion Model 1
                              |
                              v
                       Model 3 Distress
                              |
                              v
                            Llama
                              |
                              v
                    Conversational response
```

---

# 14. Model 3 — Calibrated Distress Prediction

Model 3 provides the numerical distress prediction layer.

The model is a calibrated Ridge regression model trained using emotion probabilities produced by Emotion Model 1.

## Current architecture

```text
Emotion Model 1
      |
      +-- 11 emotion probabilities
      |
      v
Model 3 — Calibrated Ridge
      |
      +-- Distress score (0–100)
      +-- Risk level
      +-- Trend direction
      +-- Previous score
      +-- Score change
      |
      v
Prediction Storage in Supabase
```

Model 3 implementation:

```text
ai/inference/distress_predictor.py
```

Trained model:

```text
ai/training/calibrated_distress_model.pkl
```

Training script:

```text
ai/training/train_calibrated_model.py
```

The model uses these emotion features:

```text
anger
contempt
disgust
fear
frustration
gratitude
joy
love
neutral
sadness
surprise
```

The trained model is loaded with joblib and uses scikit-learn Ridge regression for inference.

The predicted distress score is clipped to the 0–100 range.

---

## Risk Levels

```text
0–25       LOW
26–50      MODERATE
51–75      HIGH
76–100     CRITICAL
```

---

## Trend Directions

```text
INCREASING
DECREASING
STABLE
NO_PREVIOUS_DATA
```

Trend calculation is based on the change between the current distress score and the previous distress score.

For subsequent assessments, the backend retrieves the previous prediction for the victim and sends the previous distress score to Model 3.

The prediction output includes:

```text
interaction_id
distress_score
risk_level
confidence
trend_direction
previous_score
score_change
model_version
```

Current model version:

```text
calibrated_ridge
```

Model 3 is integrated into both the text and voice assessment pipelines.

Its prediction is stored in the Supabase `predictions` table.

---

# 15. Supabase

The backend uses Supabase for persistent storage.

Client:

```text
backend/app/database/supabase_client.py
```

The backend currently stores information including:

```text
victims
interactions
emotion_results
predictions
```

General relationship:

```text
Victim
  |
  v
Interaction
  |
  +------> Emotion Result
  |
  +------> Distress Prediction
```

---

# 16. Text Assessment Service

The text assessment service is:

```text
backend/app/services/assessment_service.py
```

Current behavior:

1. Retrieves recent conversation history for the victim.
2. Retrieves the previous distress score.
3. Sends the current text, recent history, and previous distress to the AI service.
4. Receives emotion scores.
5. Receives the calibrated distress prediction.
6. Receives the Llama explanation.
7. Creates the interaction in Supabase.
8. Stores the emotion scores in `emotion_results`.
9. Stores the distress prediction in `predictions`.
10. Returns the interaction, emotion result, and prediction.

The explanation is currently returned to the client but is not stored as a separate database field.

---

# 17. Voice Assessment Service

The voice assessment service is:

```text
backend/app/services/voice_assessment_service.py
```

Current behavior:

1. Reads the uploaded or recorded audio.
2. Validates that the audio is not empty.
3. Retrieves recent conversation history for the victim.
4. Retrieves the previous distress score.
5. Converts the audio to WAV format using FFmpeg.
6. Sends the WAV audio, recent history, and previous distress to `/api/analyze/speech`.
7. Receives transcription, emotion scores, distress prediction, and explanation.
8. Creates an interaction in Supabase.
9. Stores the emotion result.
10. Stores the distress prediction.
11. Returns the interaction, emotion result, and prediction.

The uploaded filename is stored as `voice_reference`.

---

# 18. Testing

## Check AI Service Port

```powershell
Test-NetConnection 127.0.0.1 -Port 8001
```

Expected:

```text
TcpTestSucceeded : True
```

## Check Backend Port

```powershell
Test-NetConnection 127.0.0.1 -Port 8000
```

Expected:

```text
TcpTestSucceeded : True
```

---

## Direct AI Text Test

From the `ai` directory:

```powershell
python -c "from inference.ai_service import process_text; print(process_text('I am feeling very scared and unsafe because of the threats.', conversation_history=[], previous_distress=None))"
```

Expected output contains:

```text
emotions
distress
explanation
```

---

## Direct AI Speech Test

```powershell
python -c "import requests; f=r'D:\Downloads\test_sample4.wav'; r=requests.post('http://127.0.0.1:8001/api/analyze/speech', files={'audio':('test_sample4.wav',open(f,'rb'),'audio/wav')}); print(r.status_code); print(r.text)"
```

Expected:

```text
200
```

The result should contain:

```text
input_type
text
emotions
distress
explanation
```

---

# Backend Text Assessment Test

Set a valid victim ID:

```powershell
$victimId = "<victim-id>"
```

Then:

```powershell
$body = @{
    victim_id = $victimId
    text_response = "I am feeling very scared and unsafe because of the threats."
    voice_reference = $null
} | ConvertTo-Json

$r = Invoke-RestMethod `
    -Uri "http://127.0.0.1:8000/api/assessments/" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body

$r | ConvertTo-Json -Depth 10
```

Expected:

```text
Assessment created successfully
```

with:

```text
interaction
emotion_result
prediction
```

---

# Backend Voice Assessment Test

Set a valid victim ID:

```powershell
$victimId = "<victim-id>"
```

For WAV:

```powershell
python -c "import requests; f=r'D:\Downloads\test_sample4.wav'; victim_id='$victimId'; r=requests.post('http://127.0.0.1:8000/api/assessments/voice', data={'victim_id':victim_id}, files={'audio':('test_sample4.wav',open(f,'rb'),'audio/wav')}); print('Status:',r.status_code); print(r.text)"
```

For OGG:

```powershell
python -c "import requests; f=r'D:\Downloads\test.cnv.ogg'; victim_id='$victimId'; r=requests.post('http://127.0.0.1:8000/api/assessments/voice', data={'victim_id':victim_id}, files={'audio':('test.cnv.ogg',open(f,'rb'),'audio/ogg')}); print('Status:',r.status_code); print(r.text)"
```

Expected:

```text
Status: 200
```

with:

```text
interaction
emotion_result
prediction
```

The voice test verifies the complete pipeline:

```text
Audio
  ↓
Backend
  ↓
FFmpeg
  ↓
WAV
  ↓
Whisper
  ↓
Emotion Model 1
  ↓
Model 3
  ↓
Llama
  ↓
Supabase
```

---

# 19. Validation Before Commit

Run syntax checks:

```powershell
python -m py_compile ai\api.py
python -m py_compile ai\inference\ai_service.py
python -m py_compile ai\inference\distress_predictor.py
python -m py_compile ai\inference\llama_service.py

python -m py_compile backend\app\services\ai_service.py
python -m py_compile backend\app\services\assessment_service.py
python -m py_compile backend\app\services\history_service.py
python -m py_compile backend\app\services\voice_assessment_service.py
```

Check Git:

```powershell
git diff --check
git status
git diff --stat
```

---

# 20. API Documentation

When the backend is running:

```text
http://127.0.0.1:8000/docs
```

When the AI service is running:

```text
http://127.0.0.1:8001/docs
```

These Swagger/OpenAPI pages can be used to test the APIs manually.

---

# 21. Local Ports

Backend:

```text
127.0.0.1:8000
```

AI Service:

```text
127.0.0.1:8001
```

Ollama:

```text
127.0.0.1:11434
```

The three components are separate.

---

# 22. Git Rules

Do not commit:

```text
backend/.env
ai/.env
backend/venv/
ai/venv/
__pycache__/
*.pyc
```

The Llama model is managed by Ollama and is not stored in Git.

Before committing:

```powershell
git status
git diff
git diff --check
```

Stage intended files:

```powershell
git add <files>
```

Commit:

```powershell
git commit -m "describe the change"
```

Push:

```powershell
git push origin main
```

---

# 23. Current Integration Status

```text
Text
  → Backend
  → Conversation History
  → Previous Distress
  → AI Service
  → Emotion Model 1
  → Model 3
  → Llama
  → Backend
  → Supabase
  ✓

Voice
  → Backend
  → Conversation History
  → Previous Distress
  → FFmpeg
  → WAV
  → Whisper
  → Emotion Model 1
  → Model 3
  → Llama
  → Backend
  → Supabase
  ✓
```

Current major components:

```text
Emotion Model 1
    ✓ Implemented
    ✓ Text tested
    ✓ Voice tested

Whisper
    ✓ Implemented
    ✓ Voice tested

Llama / Ollama
    ✓ Implemented
    ✓ Text tested
    ✓ Voice tested

Model 3 — Calibrated Distress Prediction
    ✓ Implemented
    ✓ Text tested
    ✓ Voice tested
    ✓ Previous-score trend implemented

Conversation History
    ✓ Implemented
    ✓ Text integrated
    ✓ Voice integrated

FFmpeg Audio Conversion
    ✓ Implemented in backend voice pipeline

Supabase Persistence
    ✓ Interactions
    ✓ Emotion results
    ✓ Distress predictions
```
