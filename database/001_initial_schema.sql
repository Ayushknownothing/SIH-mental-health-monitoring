-- ============================================================
-- SIH Mental Health Monitoring System
-- Initial Database Schema
-- Database: Supabase PostgreSQL
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE victims (
    victim_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    display_name TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE interactions (
    interaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    victim_id UUID NOT NULL,

    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),

    text_response TEXT,

    voice_reference TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_interactions_victim
        FOREIGN KEY (victim_id)
        REFERENCES victims(victim_id)
        ON DELETE RESTRICT
);

CREATE TABLE emotion_results (
    emotion_result_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    interaction_id UUID NOT NULL UNIQUE,

    fear REAL,
    sadness REAL,
    anger REAL,
    nervousness REAL,
    voice_stress REAL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_emotion_results_interaction
        FOREIGN KEY (interaction_id)
        REFERENCES interactions(interaction_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_emotion_fear
        CHECK (fear IS NULL OR fear BETWEEN 0 AND 1),

    CONSTRAINT chk_emotion_sadness
        CHECK (sadness IS NULL OR sadness BETWEEN 0 AND 1),

    CONSTRAINT chk_emotion_anger
        CHECK (anger IS NULL OR anger BETWEEN 0 AND 1),

    CONSTRAINT chk_emotion_nervousness
        CHECK (nervousness IS NULL OR nervousness BETWEEN 0 AND 1),

    CONSTRAINT chk_emotion_voice_stress
        CHECK (voice_stress IS NULL OR voice_stress BETWEEN 0 AND 1)
);

CREATE TABLE predictions (
    prediction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    interaction_id UUID NOT NULL UNIQUE,

    distress_score REAL NOT NULL,

    risk_level TEXT NOT NULL,

    confidence REAL,

    trend_direction TEXT,

    previous_score REAL,

    score_change REAL,

    model_version TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_predictions_interaction
        FOREIGN KEY (interaction_id)
        REFERENCES interactions(interaction_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_distress_score
        CHECK (distress_score BETWEEN 0 AND 100),

    CONSTRAINT chk_prediction_confidence
        CHECK (
            confidence IS NULL
            OR confidence BETWEEN 0 AND 1
        ),

    CONSTRAINT chk_previous_score
        CHECK (
            previous_score IS NULL
            OR previous_score BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_risk_level
        CHECK (
            risk_level IN (
                'LOW',
                'MODERATE',
                'HIGH',
                'CRITICAL'
            )
        ),

    CONSTRAINT chk_trend_direction
        CHECK (
            trend_direction IS NULL
            OR trend_direction IN (
                'INCREASING',
                'DECREASING',
                'STABLE',
                'NO_PREVIOUS_DATA'
            )
        )
);

CREATE INDEX idx_interactions_victim_timestamp
    ON interactions(victim_id, timestamp);

CREATE INDEX idx_emotion_results_interaction
    ON emotion_results(interaction_id);

CREATE INDEX idx_predictions_interaction
    ON predictions(interaction_id);

CREATE INDEX idx_predictions_created_at
    ON predictions(created_at);


-- ============================================================
-- Historical Data Protection
-- Interactions are append-only.
-- ============================================================

CREATE OR REPLACE FUNCTION prevent_interaction_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION
        'Historical interactions cannot be updated or deleted';
END;
$$;

CREATE TRIGGER trg_prevent_interaction_update
BEFORE UPDATE OR DELETE
ON interactions
FOR EACH ROW
EXECUTE FUNCTION prevent_interaction_mutation();

-- Emotion analysis results are historical records.
-- They must not be modified after creation.

CREATE OR REPLACE FUNCTION prevent_emotion_result_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION
        'Historical emotion results cannot be updated or deleted';
END;
$$;

CREATE TRIGGER trg_prevent_emotion_result_update
BEFORE UPDATE OR DELETE
ON emotion_results
FOR EACH ROW
EXECUTE FUNCTION prevent_emotion_result_mutation();

-- Predictions are historical records.
-- A new prediction creates a new row.

CREATE OR REPLACE FUNCTION prevent_prediction_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION
        'Historical predictions cannot be updated or deleted';
END;
$$;

CREATE TRIGGER trg_prevent_prediction_update
BEFORE UPDATE OR DELETE
ON predictions
FOR EACH ROW
EXECUTE FUNCTION prevent_prediction_mutation();

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE victims ENABLE ROW LEVEL SECURITY;

ALTER TABLE interactions ENABLE ROW LEVEL SECURITY;

ALTER TABLE emotion_results ENABLE ROW LEVEL SECURITY;

ALTER TABLE predictions ENABLE ROW LEVEL SECURITY;

