SIH Mental Health Monitoring — Backend


1. Overview

This directory contains the FastAPI backend for the AI-based Dynamic Mental Health Monitoring System.

The backend is responsible for:

Managing victims

Creating text assessments

Creating voice assessments

Communicating with the AI service

Managing recent conversation context

Storing interaction and emotion results in Supabase

Providing APIs for emotion results and distress predictions

Providing victim history for dynamic monitoring

Returning AI-generated explanations from the local Llama/Ollama layer

The backend connects the frontend, AI services/models, and Supabase database.


2. Current Architecture

Text Assessment

Frontend / Client
       |
       | POST /api/assessments/
       v
FastAPI Backend :8000
       |
       +----------------------------+
       |                            |
       v                            v
Recent Conversation History     Current Text
       |                            |
       +-------------+--------------+
                     |
                     v
               AI Service :8001
                     |
                     v
              Emotion Model 1
                     |
          +----------+----------+
          |                     |
          v                     v
   Emotion Scores         Ollama :11434
                                |
                                v
                         Llama 3.2:3b
                                |
                                v
                     Conversational /
                        Supportive
                       Explanation
                                |
                                v
                       Backend Response
                          /          \
                         v            v
                    Supabase       Frontend


Voice Assessment

Frontend / Client
       |
       | POST /api/assessments/voice
       v
FastAPI Backend :8000
       |
       +----------------------------+
       |                            |
       v                            v
Recent Conversation History     Current Audio
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
                         +----------+----------+
                         |                     |
                         v                     v
                  Emotion Scores        Ollama :11434
                                              |
                                              v
                                       Llama 3.2:3b
                                              |
                                              v
                                      Conversational /
                                         Supportive
                                        Explanation
                                              |
                                              v
                                      Backend Response
                                         /          \
                                        v            v
                                   Supabase       Frontend


Component Responsibilities

FastAPI Backend
    |
    +-- API handling
    +-- Victim management
    +-- Assessment management
    +-- Recent conversation history
    +-- Supabase database operations
    +-- Communication with AI service
    |
    v
AI Service
    |
    +-- Whisper speech-to-text
    +-- Emotion Model 1
    +-- Model 3 calibrated distress prediction
    +-- Llama explanation/conversation layer


3. Technology Stack

Python

FastAPI

Uvicorn

Pydantic

Supabase

PostgreSQL through Supabase

HTTPX

python-multipart for voice uploads

Whisper for speech-to-text

Hugging Face Transformers for Emotion Model 1

Ollama for local Llama inference

Llama 3.2:3b

Separate AI service on port 8001


4. Project Structure

SIH-mental-health-monitoring/
|
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   │
│   │   ├── database/
│   │   │   ├── supabase_client.py
│   │   │   └── __init__.py
│   │   │
│   │   ├── models/
│   │   │   ├── schemas.py
│   │   │   └── __init__.py
│   │   │
│   │   ├── routes/
│   │   │   ├── victims.py
│   │   │   ├── assessments.py
│   │   │   ├── voice_assessments.py
│   │   │   ├── emotion_results.py
│   │   │   ├── predictions.py
│   │   │   └── __init__.py
│   │   │
│   │   └── services/
│   │       ├── victim_service.py
│   │       ├── assessment_service.py
│   │       ├── voice_assessment_service.py
│   │       ├── emotion_service.py
│   │       ├── history_service.py
│   │       ├── prediction_service.py
│   │       ├── ai_service.py
│   │       └── __init__.py
│
│   ├── requirements.txt
│   ├── .env
│   ├── .gitignore
│   └── README.md
│
├── ai/
│   ├── inference/
│   │   ├── ai_service.py
│   │   ├── emotion_model.py
│   │   ├── llama_service.py
│   │   └── transcription.py
│
│   ├── models/
│   │   ├── stress_model.py
│   │   └── __init__.py
│
│   ├── preprocessing/
│   │   └── audio_preprocessor.py
│
│   ├── api.py
│   ├── test_api.py
│   ├── requirements.txt
│   ├── README.md
│   └── venv/
│
└── ...

venv/, __pycache__/, and .pyc files are generated/local files and should not be committed.


5. Environment Configuration

The backend uses:

backend/.env

Expected variables:

SUPABASE_URL=<your-supabase-url>
SUPABASE_KEY=<your-supabase-key>

AI_SERVICE_URL=http://127.0.0.1:8001

The AI service uses:

LLAMA_BASE_URL=http://127.0.0.1:11434
LLAMA_MODEL=llama3.2:3b

Important

Never commit .env files or secret keys to GitHub.

Each developer should create their own local environment configuration.


6. Python Environment Setup

Backend

From the repository root:

cd backend
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt

If the virtual environment does not exist:

python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt


AI Service

cd ai
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt

The AI service environment contains the required packages for Transformers, PyTorch, Whisper, FastAPI, and related inference dependencies.


7. Running the System Locally

The local system uses three services/components:

AI Service

Backend

Ollama


Terminal 1 — AI Service

cd ai
.\venv\Scripts\Activate.ps1
python -m uvicorn api:app --reload --port 8001

AI service:

http://127.0.0.1:8001


Terminal 2 — Backend

cd backend
.\venv\Scripts\Activate.ps1
python -m uvicorn app.main:app --reload --port 8000

Backend:

http://127.0.0.1:8000


Ollama

Ollama runs locally as a separate background service:

http://127.0.0.1:11434

Current model:

llama3.2:3b

Check installed models:

ollama list

Check Ollama API:

Invoke-RestMethod http://127.0.0.1:11434/api/tags

Ollama is a separate local service. It is not started by FastAPI.


Local Service Layout

Terminal 1
    AI Service :8001

Terminal 2
    Backend :8000

Ollama
    Local background service :11434


8. Backend API

Root

GET /


Health

GET /health


Victims

POST /api/victims/

GET /api/victims/{victim_id}/history


Text Assessment

POST /api/assessments/

Example request:

{
    "victim_id": "<victim-id>",
    "text_response": "I feel very scared and stressed",
    "voice_reference": null
}

The backend:

1. Retrieves recent conversation history for the victim.
2. Sends the current text and conversation history to the AI service.
3. Receives emotion results and the Llama explanation.
4. Receives the distress prediction from Model 3.
5. Creates the interaction in Supabase.
6. Stores the emotion result in Supabase.
7. Stores the distress prediction in the predictions table.
8. Returns the interaction, emotion result, and prediction to the client.


Voice Assessment

POST /api/assessments/voice

Multipart form:

victim_id = <victim-id>
audio = <audio-file>

The backend:

1. Retrieves recent conversation history for the victim.
2. Sends the audio and conversation history to the AI service.
3. The AI service transcribes the audio using Whisper.
4. The transcribed text is analyzed by Emotion Model 1.
5. Llama generates the explanation using the supplied context.
6. The backend creates the interaction in Supabase.
7. The backend stores the emotion result.
8. The result is returned to the client.


Emotion Results

POST /api/emotion-results/


Predictions

POST /api/predictions/

The prediction endpoint/schema is prepared for Model 3 calibrated distress prediction.


9. AI Service

The AI service is a separate FastAPI application.

Location:

ai/

Main API:

ai/api.py

Endpoints:

POST /api/analyze/text

POST /api/analyze/speech


Text

Text
  ↓
Recent Conversation History
  ↓
Emotion Model 1
  ↓
Emotion scores
  ↓
Model 3 — Calibrated Distress Prediction
  ↓
Distress score + risk + trend
  ↓
Llama 3.2:3b through Ollama
  ↓
Supportive / Conversational explanation
  ↓
AI service response


Speech

Audio
  ↓
Whisper
  ↓
Transcribed text
  ↓
Recent Conversation History
  ↓
Emotion Model 1
  ↓
Emotion scores
  ↓
Model 3 — Calibrated Distress Prediction
  ↓
Distress score + risk + trend
  ↓
Llama 3.2:3b through Ollama
  ↓
Supportive / Conversational explanation
  ↓
AI service response


10. Emotion Model 1

Emotion Model 1 is currently integrated and tested.

It produces:

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


Example:

Input:

I feel very scared and stressed


Possible result:

fear ≈ 0.996
sadness ≈ 0.056
frustration ≈ 0.049

The actual values depend on the model input.

The backend stores these values in the emotion_results table.


Status

IMPLEMENTED AND TESTED

Both text and voice emotion flows have been tested successfully.


11. Whisper Speech-to-Text

Voice processing uses OpenAI Whisper.

Location in the AI service:

ai/inference/transcription.py


Pipeline:

Audio file
   ↓
Whisper
   ↓
Text transcription


The transcribed text is then passed to Emotion Model 1 and the Llama conversational layer.

Whisper currently runs on CPU in the local setup.

On Windows, the required audio/Whisper environment may require FFmpeg to be available.


12. Llama / Ollama Integration

Llama is currently implemented as the conversational/explanation layer.

Ollama:

http://127.0.0.1:11434

Model:

llama3.2:3b

AI service implementation:

ai/inference/llama_service.py


Role of Llama

Llama is responsible for:

Explaining emotion results

Producing simple human-readable responses

Providing supportive language

Maintaining conversational continuity using supplied recent history

Asking relevant follow-up questions

Keeping explanations non-diagnostic

Explaining supplied model outputs without replacing the ML models


Llama must not:

Diagnose a mental health condition

Invent distress scores

Calculate the core distress prediction

Change a risk level generated by Model 3

Replace the ML prediction models

The numerical prediction should come from the defined ML pipeline.


Current Flow

Current user message
        |
        +-----------------------+
        |                       |
        v                       v
Emotion Model 1        Recent Conversation History
        |                       |
        +-----------+-----------+
                    |
                    v
                  Llama
                    |
                    v
        Conversational Explanation
                    |
                    v
                 Backend
                    |
                    v
             Frontend / API client


The current implementation returns the explanation in the API response.

The explanation is currently not stored as a separate database column.


12.1 Conversational Context

The AI service supports conversation-aware responses.

For each new assessment, the backend retrieves the victim's recent interaction history from Supabase.

The complete interaction history remains stored in Supabase.

Only a limited number of recent messages are sent to the AI service as conversational context.

Current configuration:

MAX_CONVERSATION_MESSAGES = 6


Conversation history is retrieved through:

backend/app/services/history_service.py


The shared function is:

get_recent_conversation_history(victim_id)


The function:

1. Retrieves the victim's stored interactions.
2. Converts recent text responses into conversation messages.
3. Reverses the order so messages are chronological.
4. Limits the context to the most recent six messages.
5. Returns the context to the assessment service.


Conversation history format:

[
    {
        "role": "user",
        "content": "Previous user message"
    },
    {
        "role": "user",
        "content": "Another previous message"
    }
]


Text conversation flow:

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
                  Llama
                    |
                    v
          Conversational response


Voice conversation flow:

Previous interactions
        |
        v
Recent conversation history
        |
        +-----------------------+
        |                       |
        v                       v
Current audio             Whisper
                                |
                                v
                         Transcribed text
                                |
                                v
                         Emotion Model 1
                                |
                                +-----------+
                                            |
                                            v
                                          Llama
                                            |
                                            v
                                  Conversational response


The backend passes conversation history to the AI service.

Text requests send:

text

conversation_history


Voice requests send:

audio

conversation_history


The AI service receives the history and provides it to the Llama explanation layer.

Conversation history does not replace the emotion model.

Conversation history does not replace Model 3.

The complete history remains available through:

GET /api/victims/{victim_id}/history


Conversation-aware components:

backend/app/services/history_service.py
    |
    +-- get_victim_history()
    |
    +-- get_recent_conversation_history()

backend/app/services/assessment_service.py
    |
    +-- Text conversation context

backend/app/services/voice_assessment_service.py
    |
    +-- Voice conversation context

backend/app/services/ai_service.py
    |
    +-- Sends conversation_history to AI service

ai/api.py
    |
    +-- Accepts conversation_history

ai/inference/ai_service.py
    |
    +-- Passes conversation_history to Llama

ai/inference/llama_service.py
    |
    +-- Generates conversational explanation


Status

IMPLEMENTED AND TESTED

Text and voice assessment APIs successfully return Llama-generated explanations.

Recent conversation context is supported by the backend and AI service.


13. Text Assessment End-to-End Flow

User enters text
       |
       v
POST /api/assessments/
       |
       v
Backend :8000
       |
       +----------------------+
       |                      |
       v                      v
Recent History          Current Text
       |                      |
       +----------+-----------+
                  |
                  v
            AI Service :8001
                  |
                  v
            Emotion Model 1
                  |
                  +------------------+
                  |                  |
                  v                  v
            Emotion scores        Llama
                                      |
                                      v
                                  Explanation
                  |                  |
                  +--------+---------+
                           |
                           v
                      Backend :8000
                       /             \
                      v               v
                 Supabase          Frontend


14. Voice Assessment End-to-End Flow

User uploads audio
       |
       v
POST /api/assessments/voice
       |
       v
Backend :8000
       |
       +----------------------+
       |                      |
       v                      v
Recent History          Current Audio
                              |
                              v
                        AI Service :8001
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
                              +------------------+
                              |                  |
                              v                  v
                        Emotion scores        Llama
                                                  |
                                                  v
                                              Explanation
                              |                  |
                              +--------+---------+
                                       |
                                       v
                                  Backend :8000
                                   /             \
                                  v               v
                             Supabase          Frontend


15. Supabase

The backend uses Supabase for persistent storage.

Client:

backend/app/database/supabase_client.py


The backend currently stores information including:

victims

interactions

emotion_results

predictions


For an assessment, the general relationship is:

Victim
  |
  v
Interaction
  |
  v
Emotion Result
  |
  v
Distress Prediction


The database schema is maintained separately from this README.


16. Text Assessment Service

The text assessment service:

backend/app/services/assessment_service.py


Current behavior:

1. Retrieves recent conversation history for the victim.
2. Sends the current text and recent history to the backend AI service.
3. Receives emotion scores.
4. Receives the Llama explanation.
5. Creates the interaction in Supabase.
6. Stores the emotion scores in emotion_results.
7. Adds the explanation to the returned API object.
8. Returns the interaction and emotion result.


The explanation is returned to the client but is not currently stored as a separate Supabase field.


17. Voice Assessment Service

The voice assessment service:

backend/app/services/voice_assessment_service.py


Current behavior:

1. Reads the uploaded audio.
2. Retrieves recent conversation history for the victim.
3. Sends the audio and recent history to /api/analyze/speech on the AI service.
4. Receives transcription, emotion scores, and explanation.
5. Creates an interaction in Supabase.
6. Stores the emotion result.
7. Adds the Llama explanation to the returned API object.
8. Returns the interaction and emotion result.


The uploaded filename is stored as voice_reference.

The audio is processed through the AI service rather than being permanently stored by this service.


18. Model 3 — Calibrated Distress Prediction

Model 3 provides the numerical distress prediction layer.

The model is a calibrated Ridge regression model trained using the
emotion probabilities produced by Emotion Model 1.

Current architecture:

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

Model 3 implementation:

ai/inference/distress_predictor.py

Trained model:

ai/training/calibrated_distress_model.pkl

Training script:

ai/training/train_calibrated_model.py

The training script uses these emotion features:

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

The trained model is loaded with joblib and uses scikit-learn Ridge
regression for inference.

The predicted distress score is clipped to the 0–100 range.

Risk levels:

LOW

MODERATE

HIGH

CRITICAL

Trend directions:

INCREASING

DECREASING

STABLE

NO_PREVIOUS_DATA

For subsequent assessments, the backend retrieves the previous
prediction for the victim and sends the previous distress score to
Model 3.

The prediction output includes:

interaction_id

distress_score

risk_level

confidence

trend_direction

previous_score

score_change

model_version

The current model version returned by the integration is:

calibrated_ridge

Model 3 is integrated into the text assessment pipeline and its
prediction is stored in the Supabase predictions table.

Current Status

MODEL 3: IMPLEMENTED AND TESTED

First-assessment and repeated-assessment trend behavior have been
tested successfully.

Example verified behavior:

First assessment:
distress_score = 89.74
risk_level = CRITICAL
trend_direction = NO_PREVIOUS_DATA
previous_score = null

Second assessment:
distress_score = 89.33
risk_level = CRITICAL
trend_direction = STABLE
previous_score = 89.74
score_change = -0.41

The example values above are from a local integration test and are
not fixed outputs for future inputs.

Model 3 Dependencies

The AI service requirements include:

joblib
pandas
scikit-learn

These packages are required to load and run the calibrated distress
prediction model.

Llama remains the conversational explanation layer and does not
generate, calculate, or modify the numerical distress prediction.


19. Current Testing

Direct AI Text Test

Example:

python -c "from inference.ai_service import process_text; print(process_text('I feel very scared and stressed'))"


This successfully produces:

Emotion scores

Llama explanation


AI Speech Test

Example:

python -c "import requests; f=r'D:\Downloads\test_sample4.wav'; r=requests.post('http://127.0.0.1:8001/api/analyze/speech', files={'audio': ('test_sample4.wav', open(f,'rb'), 'audio/wav')}); print('Status:', r.status_code); print(r.json())"


This successfully produces:

Whisper transcription

Emotion scores

Llama explanation


Backend Text Assessment Test

The backend successfully returned:

Assessment created successfully

with:

interaction

emotion_result

explanation


Backend Voice Assessment Test

The backend successfully returned:

Voice assessment created successfully

with:

interaction

emotion_result

explanation


Conversational Context Test

The conversational architecture was tested using multiple assessments for the same victim.

Example flow:

Text message
    |
    v
Store interaction
    |
    v
Next message
    |
    v
Retrieve recent history
    |
    v
Send history + current message to AI
    |
    v
Emotion Model + Llama
    |
    v
Conversational response


The system supports both text and voice assessments in the conversation flow.

Voice assessments are converted to text using Whisper before emotion analysis and Llama processing.

The complete interaction history remains stored in Supabase.

Only recent messages are supplied as conversational context.


Current Local Integration Status

Text → Backend → History + AI → Emotion → Model 3 → Llama → Backend → Supabase    ✓

Voice → Backend → History + Whisper → Emotion → Model 3 → Llama → Backend → Supabase    ✓


20. Local Ports

Backend:

127.0.0.1:8000


AI Service:

127.0.0.1:8001


Ollama:

127.0.0.1:11434


The three components are separate.


Terminal 1

    AI Service :8001


Terminal 2

    Backend :8000


Ollama

    Local background service :11434


21. API Documentation

When the backend is running:

http://127.0.0.1:8000/docs


When the AI service is running:

http://127.0.0.1:8001/docs


These Swagger/OpenAPI pages can be used to test the APIs manually.


22. Important Git Rules

Do not commit:

backend/.env

ai/.env

backend/venv/

ai/venv/

__pycache__/

*.pyc


The Llama model itself is managed by Ollama and is not stored in Git.


Before committing:

git status

git diff

git diff --check


Then stage only the intended files:

git add <files>


Commit:

git commit -m "describe the change"


Push only when ready:

git push origin main