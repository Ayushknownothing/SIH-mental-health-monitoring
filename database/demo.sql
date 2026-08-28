-- ============================================================
-- SIH Mental Health Monitoring System
-- Demo / Seed Data
-- Database: Supabase PostgreSQL
-- ============================================================
--
-- PURPOSE:
-- Synthetic text-first data for development, testing,
-- dashboard visualization, and longitudinal monitoring.
--
-- IMPORTANT:
-- - All data in this file is synthetic.
-- - No real victim information is used.
-- - The prototype primarily operates on text responses.
-- - voice_reference is intentionally NULL in this demo.
-- - Each interaction has one emotion result.
-- - Each interaction has one prediction.
-- - Historical records are never updated.
--
-- ============================================================


-- ============================================================
-- 1. Create demo victim
-- ============================================================

INSERT INTO victims (
    display_name
)
SELECT
    'Victim 001'
WHERE NOT EXISTS (
    SELECT 1
    FROM victims
    WHERE display_name = 'Victim 001'
);


-- ============================================================
-- 2. Create five historical text interactions
-- ============================================================
--
-- The five responses represent a synthetic progression
-- from lower to higher distress.
--
-- voice_reference is NULL because this prototype is
-- primarily text-based.
--
-- ============================================================


-- Interaction 1
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    victim_id,
    now() - interval '4 hours',
    'I am feeling somewhat worried today.',
    NULL
FROM victims
WHERE display_name = 'Victim 001'
  AND NOT EXISTS (
      SELECT 1
      FROM interactions
      WHERE victim_id = victims.victim_id
        AND text_response = 'I am feeling somewhat worried today.'
  );


-- Interaction 2
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    victim_id,
    now() - interval '3 hours',
    'I am becoming more anxious.',
    NULL
FROM victims
WHERE display_name = 'Victim 001'
  AND NOT EXISTS (
      SELECT 1
      FROM interactions
      WHERE victim_id = victims.victim_id
        AND text_response = 'I am becoming more anxious.'
  );


-- Interaction 3
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    victim_id,
    now() - interval '2 hours',
    'I am feeling very stressed now.',
    NULL
FROM victims
WHERE display_name = 'Victim 001'
  AND NOT EXISTS (
      SELECT 1
      FROM interactions
      WHERE victim_id = victims.victim_id
        AND text_response = 'I am feeling very stressed now.'
  );


-- Interaction 4
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    victim_id,
    now() - interval '1 hour',
    'The situation is becoming difficult to handle.',
    NULL
FROM victims
WHERE display_name = 'Victim 001'
  AND NOT EXISTS (
      SELECT 1
      FROM interactions
      WHERE victim_id = victims.victim_id
        AND text_response = 'The situation is becoming difficult to handle.'
  );


-- Interaction 5
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    victim_id,
    now(),
    'I am feeling highly distressed.',
    NULL
FROM victims
WHERE display_name = 'Victim 001'
  AND NOT EXISTS (
      SELECT 1
      FROM interactions
      WHERE victim_id = victims.victim_id
        AND text_response = 'I am feeling highly distressed.'
  );


-- ============================================================
-- 3. Create emotion-analysis results
-- ============================================================
--
-- One emotion result per interaction.
--
-- Values are normalized between 0 and 1.
--
-- ============================================================


-- Emotion result 1
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    interaction_id,
    0.30,
    0.20,
    0.10,
    0.25,
    0.00
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling somewhat worried today.'
AND NOT EXISTS (
    SELECT 1
    FROM emotion_results e
    WHERE e.interaction_id = interactions.interaction_id
);


-- Emotion result 2
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    interaction_id,
    0.45,
    0.25,
    0.08,
    0.42,
    0.00
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am becoming more anxious.'
AND NOT EXISTS (
    SELECT 1
    FROM emotion_results e
    WHERE e.interaction_id = interactions.interaction_id
);


-- Emotion result 3
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    interaction_id,
    0.62,
    0.30,
    0.12,
    0.58,
    0.00
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling very stressed now.'
AND NOT EXISTS (
    SELECT 1
    FROM emotion_results e
    WHERE e.interaction_id = interactions.interaction_id
);


-- Emotion result 4
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    interaction_id,
    0.70,
    0.35,
    0.15,
    0.67,
    0.00
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'The situation is becoming difficult to handle.'
AND NOT EXISTS (
    SELECT 1
    FROM emotion_results e
    WHERE e.interaction_id = interactions.interaction_id
);


-- Emotion result 5
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    interaction_id,
    0.78,
    0.40,
    0.18,
    0.75,
    0.00
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling highly distressed.'
AND NOT EXISTS (
    SELECT 1
    FROM emotion_results e
    WHERE e.interaction_id = interactions.interaction_id
);


-- ============================================================
-- 4. Create distress predictions
-- ============================================================
--
-- Synthetic longitudinal progression:
--
-- 35 → 43 → 56 → 68 → 74
--
-- Risk levels:
-- 0–25   LOW
-- 26–50  MODERATE
-- 51–75  HIGH
-- 76–100 CRITICAL
--
-- ============================================================


-- Prediction 1
INSERT INTO predictions (
    interaction_id,
    distress_score,
    risk_level,
    confidence,
    trend_direction,
    previous_score,
    score_change,
    model_version
)
SELECT
    interaction_id,
    35,
    'MODERATE',
    0.82,
    'NO_PREVIOUS_DATA',
    NULL,
    NULL,
    'demo-v1'
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling somewhat worried today.'
AND NOT EXISTS (
    SELECT 1
    FROM predictions p
    WHERE p.interaction_id = interactions.interaction_id
);


-- Prediction 2
INSERT INTO predictions (
    interaction_id,
    distress_score,
    risk_level,
    confidence,
    trend_direction,
    previous_score,
    score_change,
    model_version
)
SELECT
    interaction_id,
    43,
    'MODERATE',
    0.84,
    'INCREASING',
    35,
    8,
    'demo-v1'
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am becoming more anxious.'
AND NOT EXISTS (
    SELECT 1
    FROM predictions p
    WHERE p.interaction_id = interactions.interaction_id
);


-- Prediction 3
INSERT INTO predictions (
    interaction_id,
    distress_score,
    risk_level,
    confidence,
    trend_direction,
    previous_score,
    score_change,
    model_version
)
SELECT
    interaction_id,
    56,
    'HIGH',
    0.86,
    'INCREASING',
    43,
    13,
    'demo-v1'
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling very stressed now.'
AND NOT EXISTS (
    SELECT 1
    FROM predictions p
    WHERE p.interaction_id = interactions.interaction_id
);


-- Prediction 4
INSERT INTO predictions (
    interaction_id,
    distress_score,
    risk_level,
    confidence,
    trend_direction,
    previous_score,
    score_change,
    model_version
)
SELECT
    interaction_id,
    68,
    'HIGH',
    0.87,
    'INCREASING',
    56,
    12,
    'demo-v1'
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'The situation is becoming difficult to handle.'
AND NOT EXISTS (
    SELECT 1
    FROM predictions p
    WHERE p.interaction_id = interactions.interaction_id
);


-- Prediction 5
INSERT INTO predictions (
    interaction_id,
    distress_score,
    risk_level,
    confidence,
    trend_direction,
    previous_score,
    score_change,
    model_version
)
SELECT
    interaction_id,
    74,
    'HIGH',
    0.89,
    'INCREASING',
    68,
    6,
    'demo-v1'
FROM interactions
WHERE victim_id = (
    SELECT victim_id
    FROM victims
    WHERE display_name = 'Victim 001'
    LIMIT 1
)
AND text_response = 'I am feeling highly distressed.'
AND NOT EXISTS (
    SELECT 1
    FROM predictions p
    WHERE p.interaction_id = interactions.interaction_id
);


-- ============================================================
-- 5. Final verification
-- ============================================================

SELECT
    v.display_name,
    i.timestamp AS interaction_time,
    i.text_response,

    e.fear,
    e.sadness,
    e.anger,
    e.nervousness,

    p.distress_score,
    p.risk_level,
    p.trend_direction,
    p.previous_score,
    p.score_change,
    p.confidence,
    p.model_version

FROM victims v

INNER JOIN interactions i
    ON i.victim_id = v.victim_id

INNER JOIN emotion_results e
    ON e.interaction_id = i.interaction_id

INNER JOIN predictions p
    ON p.interaction_id = i.interaction_id

WHERE v.display_name = 'Victim 001'

ORDER BY i.timestamp ASC;
