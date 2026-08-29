from fastapi import FastAPI
from app.routes import victims, assessments, emotion_results, predictions

app = FastAPI(
    title="AI Mental Health Monitoring System",
    description="Backend API for dynamic distress monitoring",
    version="1.0.0"
)

app.include_router(victims.router)
app.include_router(assessments.router)
app.include_router(emotion_results.router)
app.include_router(predictions.router)


@app.get("/")
def root():
    return {
        "message": "Mental Health Monitoring Backend is running"
    }


@app.get("/health")
def health_check():
    return {
        "status": "healthy"
    }