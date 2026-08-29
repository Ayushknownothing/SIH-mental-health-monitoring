from pydantic import BaseModel, Field
from typing import Optional


class VictimCreate(BaseModel):
    display_name: Optional[str] = None


class AssessmentCreate(BaseModel):
    victim_id: str
    text_response: str | None = None
    voice_reference: str | None = None


class EmotionResultCreate(BaseModel):
    interaction_id: str
    input_type: str

    anger: float | None = Field(default=None, ge=0, le=1)
    contempt: float | None = Field(default=None, ge=0, le=1)
    disgust: float | None = Field(default=None, ge=0, le=1)
    fear: float | None = Field(default=None, ge=0, le=1)
    frustration: float | None = Field(default=None, ge=0, le=1)
    gratitude: float | None = Field(default=None, ge=0, le=1)
    joy: float | None = Field(default=None, ge=0, le=1)
    love: float | None = Field(default=None, ge=0, le=1)
    neutral: float | None = Field(default=None, ge=0, le=1)
    sadness: float | None = Field(default=None, ge=0, le=1)
    surprise: float | None = Field(default=None, ge=0, le=1)


class PredictionCreate(BaseModel):
    interaction_id: str

    distress_score: float = Field(
        ge=0,
        le=100
    )

    risk_level: str = Field(
    pattern="^(LOW|MODERATE|HIGH|CRITICAL)$"
    )

    confidence: float | None = Field(
        default=None,
        ge=0,
        le=1
    )

    trend_direction: str | None = Field(
    default=None,
    pattern="^(INCREASING|DECREASING|STABLE|NO_PREVIOUS_DATA)$"
    )
    previous_score: float | None = Field(
        default=None,
        ge=0,
        le=100
    )

    score_change: float | None = None

    model_version: str | None = None