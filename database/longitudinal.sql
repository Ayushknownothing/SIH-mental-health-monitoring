-- ============================================================
-- SIH Mental Health Monitoring System
-- Longitudinal Queries
-- Database: Supabase PostgreSQL
-- ============================================================


-- ============================================================
-- 1. Complete distress history for a victim
-- ============================================================
--
-- Used by:
-- - Longitudinal distress graph
-- - Historical monitoring
-- - Trend visualization
--
-- $1 = victim_id
-- ============================================================

SELECT
    i.interaction_id,
    i.victim_id,
    i.timestamp AS interaction_timestamp,

    p.prediction_id,
    p.distress_score,
    p.risk_level,
    p.trend_direction,
    p.previous_score,
    p.score_change,
    p.confidence,
    p.model_version,
    p.created_at AS prediction_created_at

FROM interactions i

INNER JOIN predictions p
    ON p.interaction_id = i.interaction_id

WHERE i.victim_id = $1

ORDER BY i.timestamp ASC;


-- ============================================================
-- 2. Latest prediction for a victim
-- ============================================================
--
-- Used by:
-- - Current distress indicator
-- - Current risk status
-- - Current trend
--
-- $1 = victim_id
-- ============================================================

SELECT
    i.interaction_id,
    i.timestamp AS interaction_timestamp,

    p.prediction_id,
    p.distress_score,
    p.risk_level,
    p.trend_direction,
    p.previous_score,
    p.score_change,
    p.confidence,
    p.model_version,
    p.created_at AS prediction_created_at

FROM interactions i

INNER JOIN predictions p
    ON p.interaction_id = i.interaction_id

WHERE i.victim_id = $1

ORDER BY i.timestamp DESC

LIMIT 1;


-- ============================================================
-- 3. Recent interactions for a victim
-- ============================================================
--
-- Returns the latest 10 check-ins.
--
-- $1 = victim_id
-- ============================================================

SELECT
    interaction_id,
    victim_id,
    timestamp,
    text_response,
    voice_reference,
    created_at

FROM interactions

WHERE victim_id = $1

ORDER BY timestamp DESC

LIMIT 10;


-- ============================================================
-- 4. Emotion history for a victim
-- ============================================================
--
-- Used by:
-- - Emotion trend visualization
-- - Historical emotion analysis
--
-- $1 = victim_id
-- ============================================================

SELECT
    i.interaction_id,
    i.timestamp AS interaction_timestamp,

    e.emotion_result_id,
    e.fear,
    e.sadness,
    e.anger,
    e.nervousness,
    e.voice_stress,
    e.created_at AS emotion_result_created_at

FROM interactions i

INNER JOIN emotion_results e
    ON e.interaction_id = i.interaction_id

WHERE i.victim_id = $1

ORDER BY i.timestamp ASC;


-- ============================================================
-- 5. Risk-level distribution for a victim
-- ============================================================
--
-- Counts how many predictions fall into each risk category.
--
-- $1 = victim_id
-- ============================================================

SELECT
    p.risk_level,
    COUNT(*) AS assessment_count

FROM interactions i

INNER JOIN predictions p
    ON p.interaction_id = i.interaction_id

WHERE i.victim_id = $1

GROUP BY p.risk_level

ORDER BY
    CASE p.risk_level
        WHEN 'LOW' THEN 1
        WHEN 'MODERATE' THEN 2
        WHEN 'HIGH' THEN 3
        WHEN 'CRITICAL' THEN 4
    END;


-- ============================================================
-- 6. Interaction count for a victim
-- ============================================================
--
-- Useful for:
-- - Dashboard statistics
-- - Checking number of completed check-ins
--
-- $1 = victim_id
-- ============================================================

SELECT
    COUNT(*) AS interaction_count

FROM interactions

WHERE victim_id = $1;