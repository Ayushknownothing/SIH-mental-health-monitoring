-- ============================================================
-- SIH Mental Health Monitoring System
-- Synthetic Development Data
-- ============================================================
--
-- Purpose:
-- Populate the database with synthetic longitudinal data
-- for backend and frontend development.
--
-- This file:
--   - Does not modify the schema
--   - Does not update existing historical records
--   - Does not delete records
--   - Can be safely re-run without duplicating this dataset
--
-- ============================================================


BEGIN;


-- ============================================================
-- 1. Create synthetic victims
-- ============================================================

INSERT INTO victims (display_name)
SELECT data.display_name
FROM (
    VALUES
        ('Victim 002'),
        ('Victim 003'),
        ('Victim 004'),
        ('Victim 005'),
        ('Victim 006'),
        ('Victim 007'),
        ('Victim 008'),
        ('Victim 009')
) AS data(display_name)
WHERE NOT EXISTS (
    SELECT 1
    FROM victims v
    WHERE v.display_name = data.display_name
);


-- ============================================================
-- 2. Create synthetic interactions
-- ============================================================
--
-- Six interactions per victim.
--
-- The voice_reference values are synthetic identifiers only.
-- No real audio files are required.
--
-- ============================================================

WITH interaction_data (
    display_name,
    sequence_no,
    distress_score,
    text_response
) AS (
    VALUES

    -- Victim 002: increasing
    (
        'Victim 002',
        1,
        22.0::REAL,
        'I feel relatively calm today.'
    ),
    (
        'Victim 002',
        2,
        29.0::REAL,
        'I have been feeling a little more worried.'
    ),
    (
        'Victim 002',
        3,
        38.0::REAL,
        'Things have started to feel more difficult.'
    ),
    (
        'Victim 002',
        4,
        49.0::REAL,
        'I am finding it harder to manage my stress.'
    ),
    (
        'Victim 002',
        5,
        61.0::REAL,
        'I feel increasingly overwhelmed.'
    ),
    (
        'Victim 002',
        6,
        73.0::REAL,
        'I am experiencing a high level of distress.'
    ),

    -- Victim 003: decreasing
    (
        'Victim 003',
        1,
        78.0::REAL,
        'I am feeling very overwhelmed right now.'
    ),
    (
        'Victim 003',
        2,
        69.0::REAL,
        'I am still struggling but things feel slightly better.'
    ),
    (
        'Victim 003',
        3,
        57.0::REAL,
        'I feel somewhat more in control today.'
    ),
    (
        'Victim 003',
        4,
        46.0::REAL,
        'My stress has started to decrease.'
    ),
    (
        'Victim 003',
        5,
        34.0::REAL,
        'I am feeling more settled today.'
    ),
    (
        'Victim 003',
        6,
        24.0::REAL,
        'I feel relatively calm now.'
    ),

    -- Victim 004: stable
    (
        'Victim 004',
        1,
        41.0::REAL,
        'I feel a little worried today.'
    ),
    (
        'Victim 004',
        2,
        42.0::REAL,
        'Things feel about the same today.'
    ),
    (
        'Victim 004',
        3,
        41.0::REAL,
        'I am managing things reasonably well.'
    ),
    (
        'Victim 004',
        4,
        43.0::REAL,
        'I still feel somewhat unsettled.'
    ),
    (
        'Victim 004',
        5,
        42.0::REAL,
        'There has not been much change.'
    ),
    (
        'Victim 004',
        6,
        43.0::REAL,
        'I feel about the same as before.'
    ),

    -- Victim 005: increasing
    (
        'Victim 005',
        1,
        18.0::REAL,
        'I am feeling calm today.'
    ),
    (
        'Victim 005',
        2,
        27.0::REAL,
        'I have some concerns on my mind.'
    ),
    (
        'Victim 005',
        3,
        39.0::REAL,
        'I have been feeling more worried lately.'
    ),
    (
        'Victim 005',
        4,
        52.0::REAL,
        'I am having difficulty managing my stress.'
    ),
    (
        'Victim 005',
        5,
        67.0::REAL,
        'I feel increasingly overwhelmed.'
    ),
    (
        'Victim 005',
        6,
        81.0::REAL,
        'I am experiencing a very high level of distress.'
    ),

    -- Victim 006: decreasing
    (
        'Victim 006',
        1,
        86.0::REAL,
        'I am feeling extremely overwhelmed today.'
    ),
    (
        'Victim 006',
        2,
        76.0::REAL,
        'Things are still difficult but slightly better.'
    ),
    (
        'Victim 006',
        3,
        68.0::REAL,
        'I feel somewhat less overwhelmed today.'
    ),
    (
        'Victim 006',
        4,
        54.0::REAL,
        'My stress seems to be coming down.'
    ),
    (
        'Victim 006',
        5,
        41.0::REAL,
        'I am feeling more settled.'
    ),
    (
        'Victim 006',
        6,
        28.0::REAL,
        'I feel much calmer today.'
    ),

    -- Victim 007: persistently critical/high
    (
        'Victim 007',
        1,
        79.0::REAL,
        'I am under a lot of pressure today.'
    ),
    (
        'Victim 007',
        2,
        82.0::REAL,
        'The pressure has continued.'
    ),
    (
        'Victim 007',
        3,
        88.0::REAL,
        'I am finding things very difficult to manage.'
    ),
    (
        'Victim 007',
        4,
        91.0::REAL,
        'I feel extremely overwhelmed.'
    ),
    (
        'Victim 007',
        5,
        87.0::REAL,
        'I am still experiencing significant distress.'
    ),
    (
        'Victim 007',
        6,
        93.0::REAL,
        'I continue to feel extremely overwhelmed.'
    ),

    -- Victim 008: fluctuating
    (
        'Victim 008',
        1,
        31.0::REAL,
        'I have some things worrying me today.'
    ),
    (
        'Victim 008',
        2,
        44.0::REAL,
        'I am feeling more unsettled than yesterday.'
    ),
    (
        'Victim 008',
        3,
        40.0::REAL,
        'I feel a little better today.'
    ),
    (
        'Victim 008',
        4,
        48.0::REAL,
        'Some of the stress has returned.'
    ),
    (
        'Victim 008',
        5,
        45.0::REAL,
        'I am managing but still somewhat worried.'
    ),
    (
        'Victim 008',
        6,
        51.0::REAL,
        'I am feeling more stressed again.'
    ),

    -- Victim 009: recovery
    (
        'Victim 009',
        1,
        71.0::REAL,
        'I have been feeling very stressed lately.'
    ),
    (
        'Victim 009',
        2,
        75.0::REAL,
        'The stress feels slightly worse today.'
    ),
    (
        'Victim 009',
        3,
        69.0::REAL,
        'I am beginning to feel a little better.'
    ),
    (
        'Victim 009',
        4,
        58.0::REAL,
        'Things feel somewhat more manageable.'
    ),
    (
        'Victim 009',
        5,
        45.0::REAL,
        'I am feeling more settled today.'
    ),
    (
        'Victim 009',
        6,
        36.0::REAL,
        'I feel considerably calmer than before.'
    )
)
INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    v.victim_id,
    now() - ((6 - d.sequence_no) * INTERVAL '1 day'),
    d.text_response,
    'dummy/'
        || lower(replace(d.display_name, ' ', '_'))
        || '/interaction_'
        || d.sequence_no
        || '.txt'
FROM interaction_data d
INNER JOIN victims v
    ON v.display_name = d.display_name
WHERE NOT EXISTS (
    SELECT 1
    FROM interactions existing
    WHERE existing.voice_reference =
        'dummy/'
        || lower(replace(d.display_name, ' ', '_'))
        || '/interaction_'
        || d.sequence_no
        || '.txt'
);


-- ============================================================
-- 3. Create synthetic emotion results
-- ============================================================
--
-- Values are normalized between 0 and 1.
-- They represent synthetic model outputs only.
--
-- ============================================================

WITH emotion_data (
    display_name,
    sequence_no,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
) AS (
    VALUES

    ('Victim 002', 1, 0.18::REAL, 0.12::REAL, 0.05::REAL, 0.20::REAL, 0.16::REAL),
    ('Victim 002', 2, 0.25::REAL, 0.16::REAL, 0.07::REAL, 0.28::REAL, 0.24::REAL),
    ('Victim 002', 3, 0.34::REAL, 0.22::REAL, 0.10::REAL, 0.36::REAL, 0.32::REAL),
    ('Victim 002', 4, 0.43::REAL, 0.29::REAL, 0.12::REAL, 0.45::REAL, 0.41::REAL),
    ('Victim 002', 5, 0.57::REAL, 0.35::REAL, 0.15::REAL, 0.59::REAL, 0.55::REAL),
    ('Victim 002', 6, 0.69::REAL, 0.42::REAL, 0.19::REAL, 0.72::REAL, 0.68::REAL),

    ('Victim 003', 1, 0.73::REAL, 0.46::REAL, 0.20::REAL, 0.76::REAL, 0.79::REAL),
    ('Victim 003', 2, 0.64::REAL, 0.40::REAL, 0.17::REAL, 0.68::REAL, 0.70::REAL),
    ('Victim 003', 3, 0.52::REAL, 0.34::REAL, 0.14::REAL, 0.56::REAL, 0.59::REAL),
    ('Victim 003', 4, 0.41::REAL, 0.28::REAL, 0.11::REAL, 0.45::REAL, 0.47::REAL),
    ('Victim 003', 5, 0.29::REAL, 0.21::REAL, 0.08::REAL, 0.34::REAL, 0.36::REAL),
    ('Victim 003', 6, 0.20::REAL, 0.14::REAL, 0.05::REAL, 0.24::REAL, 0.25::REAL),

    ('Victim 004', 1, 0.34::REAL, 0.25::REAL, 0.09::REAL, 0.38::REAL, 0.35::REAL),
    ('Victim 004', 2, 0.35::REAL, 0.26::REAL, 0.09::REAL, 0.39::REAL, 0.36::REAL),
    ('Victim 004', 3, 0.34::REAL, 0.25::REAL, 0.09::REAL, 0.38::REAL, 0.35::REAL),
    ('Victim 004', 4, 0.36::REAL, 0.27::REAL, 0.10::REAL, 0.40::REAL, 0.37::REAL),
    ('Victim 004', 5, 0.35::REAL, 0.26::REAL, 0.09::REAL, 0.39::REAL, 0.36::REAL),
    ('Victim 004', 6, 0.36::REAL, 0.27::REAL, 0.10::REAL, 0.40::REAL, 0.37::REAL),

    ('Victim 005', 1, 0.12::REAL, 0.09::REAL, 0.04::REAL, 0.14::REAL, 0.11::REAL),
    ('Victim 005', 2, 0.20::REAL, 0.13::REAL, 0.06::REAL, 0.22::REAL, 0.19::REAL),
    ('Victim 005', 3, 0.30::REAL, 0.19::REAL, 0.08::REAL, 0.32::REAL, 0.28::REAL),
    ('Victim 005', 4, 0.44::REAL, 0.28::REAL, 0.12::REAL, 0.47::REAL, 0.43::REAL),
    ('Victim 005', 5, 0.58::REAL, 0.36::REAL, 0.16::REAL, 0.62::REAL, 0.57::REAL),
    ('Victim 005', 6, 0.76::REAL, 0.44::REAL, 0.20::REAL, 0.79::REAL, 0.75::REAL),

    ('Victim 006', 1, 0.81::REAL, 0.48::REAL, 0.21::REAL, 0.84::REAL, 0.82::REAL),
    ('Victim 006', 2, 0.71::REAL, 0.43::REAL, 0.18::REAL, 0.74::REAL, 0.73::REAL),
    ('Victim 006', 3, 0.62::REAL, 0.38::REAL, 0.15::REAL, 0.65::REAL, 0.64::REAL),
    ('Victim 006', 4, 0.47::REAL, 0.30::REAL, 0.12::REAL, 0.50::REAL, 0.49::REAL),
    ('Victim 006', 5, 0.35::REAL, 0.24::REAL, 0.09::REAL, 0.38::REAL, 0.37::REAL),
    ('Victim 006', 6, 0.22::REAL, 0.15::REAL, 0.06::REAL, 0.25::REAL, 0.24::REAL),

    ('Victim 007', 1, 0.74::REAL, 0.45::REAL, 0.20::REAL, 0.77::REAL, 0.80::REAL),
    ('Victim 007', 2, 0.77::REAL, 0.47::REAL, 0.21::REAL, 0.80::REAL, 0.83::REAL),
    ('Victim 007', 3, 0.83::REAL, 0.52::REAL, 0.24::REAL, 0.86::REAL, 0.88::REAL),
    ('Victim 007', 4, 0.87::REAL, 0.55::REAL, 0.25::REAL, 0.90::REAL, 0.91::REAL),
    ('Victim 007', 5, 0.84::REAL, 0.53::REAL, 0.24::REAL, 0.87::REAL, 0.89::REAL),
    ('Victim 007', 6, 0.89::REAL, 0.57::REAL, 0.27::REAL, 0.92::REAL, 0.94::REAL),

    ('Victim 008', 1, 0.26::REAL, 0.18::REAL, 0.07::REAL, 0.29::REAL, 0.27::REAL),
    ('Victim 008', 2, 0.38::REAL, 0.25::REAL, 0.10::REAL, 0.41::REAL, 0.39::REAL),
    ('Victim 008', 3, 0.34::REAL, 0.22::REAL, 0.09::REAL, 0.37::REAL, 0.35::REAL),
    ('Victim 008', 4, 0.42::REAL, 0.28::REAL, 0.11::REAL, 0.45::REAL, 0.43::REAL),
    ('Victim 008', 5, 0.39::REAL, 0.26::REAL, 0.10::REAL, 0.42::REAL, 0.40::REAL),
    ('Victim 008', 6, 0.46::REAL, 0.30::REAL, 0.12::REAL, 0.49::REAL, 0.47::REAL),

    ('Victim 009', 1, 0.66::REAL, 0.41::REAL, 0.18::REAL, 0.69::REAL, 0.72::REAL),
    ('Victim 009', 2, 0.70::REAL, 0.43::REAL, 0.19::REAL, 0.73::REAL, 0.76::REAL),
    ('Victim 009', 3, 0.64::REAL, 0.39::REAL, 0.17::REAL, 0.67::REAL, 0.70::REAL),
    ('Victim 009', 4, 0.52::REAL, 0.33::REAL, 0.14::REAL, 0.55::REAL, 0.58::REAL),
    ('Victim 009', 5, 0.39::REAL, 0.26::REAL, 0.10::REAL, 0.42::REAL, 0.44::REAL),
    ('Victim 009', 6, 0.30::REAL, 0.20::REAL, 0.08::REAL, 0.33::REAL, 0.35::REAL)
)
INSERT INTO emotion_results (
    interaction_id,
    fear,
    sadness,
    anger,
    nervousness,
    voice_stress
)
SELECT
    i.interaction_id,
    e.fear,
    e.sadness,
    e.anger,
    e.nervousness,
    e.voice_stress
FROM emotion_data e
INNER JOIN victims v
    ON v.display_name = e.display_name
INNER JOIN interactions i
    ON i.victim_id = v.victim_id
   AND i.voice_reference =
        'dummy/'
        || lower(replace(e.display_name, ' ', '_'))
        || '/interaction_'
        || e.sequence_no
        || '.txt'
WHERE NOT EXISTS (
    SELECT 1
    FROM emotion_results existing
    WHERE existing.interaction_id = i.interaction_id
);


-- ============================================================
-- 4. Create synthetic predictions
-- ============================================================
--
-- previous_score, score_change, and trend_direction are
-- calculated from the chronological sequence for each victim.
--
-- ============================================================

WITH score_data (
    display_name,
    sequence_no,
    distress_score
) AS (
    VALUES

    ('Victim 002', 1, 22.0::REAL),
    ('Victim 002', 2, 29.0::REAL),
    ('Victim 002', 3, 38.0::REAL),
    ('Victim 002', 4, 49.0::REAL),
    ('Victim 002', 5, 61.0::REAL),
    ('Victim 002', 6, 73.0::REAL),

    ('Victim 003', 1, 78.0::REAL),
    ('Victim 003', 2, 69.0::REAL),
    ('Victim 003', 3, 57.0::REAL),
    ('Victim 003', 4, 46.0::REAL),
    ('Victim 003', 5, 34.0::REAL),
    ('Victim 003', 6, 24.0::REAL),

    ('Victim 004', 1, 41.0::REAL),
    ('Victim 004', 2, 42.0::REAL),
    ('Victim 004', 3, 41.0::REAL),
    ('Victim 004', 4, 43.0::REAL),
    ('Victim 004', 5, 42.0::REAL),
    ('Victim 004', 6, 43.0::REAL),

    ('Victim 005', 1, 18.0::REAL),
    ('Victim 005', 2, 27.0::REAL),
    ('Victim 005', 3, 39.0::REAL),
    ('Victim 005', 4, 52.0::REAL),
    ('Victim 005', 5, 67.0::REAL),
    ('Victim 005', 6, 81.0::REAL),

    ('Victim 006', 1, 86.0::REAL),
    ('Victim 006', 2, 76.0::REAL),
    ('Victim 006', 3, 68.0::REAL),
    ('Victim 006', 4, 54.0::REAL),
    ('Victim 006', 5, 41.0::REAL),
    ('Victim 006', 6, 28.0::REAL),

    ('Victim 007', 1, 79.0::REAL),
    ('Victim 007', 2, 82.0::REAL),
    ('Victim 007', 3, 88.0::REAL),
    ('Victim 007', 4, 91.0::REAL),
    ('Victim 007', 5, 87.0::REAL),
    ('Victim 007', 6, 93.0::REAL),

    ('Victim 008', 1, 31.0::REAL),
    ('Victim 008', 2, 44.0::REAL),
    ('Victim 008', 3, 40.0::REAL),
    ('Victim 008', 4, 48.0::REAL),
    ('Victim 008', 5, 45.0::REAL),
    ('Victim 008', 6, 51.0::REAL),

    ('Victim 009', 1, 71.0::REAL),
    ('Victim 009', 2, 75.0::REAL),
    ('Victim 009', 3, 69.0::REAL),
    ('Victim 009', 4, 58.0::REAL),
    ('Victim 009', 5, 45.0::REAL),
    ('Victim 009', 6, 36.0::REAL)
),
with_previous AS (
    SELECT
        display_name,
        sequence_no,
        distress_score,

        LAG(distress_score) OVER (
            PARTITION BY display_name
            ORDER BY sequence_no
        ) AS previous_score

    FROM score_data
)
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
    i.interaction_id,

    s.distress_score,

    CASE
        WHEN s.distress_score BETWEEN 0 AND 25
            THEN 'LOW'

        WHEN s.distress_score BETWEEN 26 AND 50
            THEN 'MODERATE'

        WHEN s.distress_score BETWEEN 51 AND 75
            THEN 'HIGH'

        WHEN s.distress_score BETWEEN 76 AND 100
            THEN 'CRITICAL'
    END,

    CASE
        WHEN s.distress_score >= 76
            THEN 0.91::REAL

        WHEN s.distress_score >= 51
            THEN 0.87::REAL

        WHEN s.distress_score >= 26
            THEN 0.84::REAL

        ELSE 0.81::REAL
    END,

    CASE
        WHEN s.previous_score IS NULL
            THEN 'NO_PREVIOUS_DATA'

        WHEN s.distress_score > s.previous_score
            THEN 'INCREASING'

        WHEN s.distress_score < s.previous_score
            THEN 'DECREASING'

        ELSE 'STABLE'
    END,

    s.previous_score,

    CASE
        WHEN s.previous_score IS NULL
            THEN NULL

        ELSE s.distress_score - s.previous_score
    END,

    CASE
        WHEN s.sequence_no <= 2
            THEN 'dummy-v1'

        WHEN s.sequence_no <= 4
            THEN 'dummy-v1.1'

        ELSE 'dummy-v2'
    END

FROM with_previous s

INNER JOIN victims v
    ON v.display_name = s.display_name

INNER JOIN interactions i
    ON i.victim_id = v.victim_id
   AND i.voice_reference =
        'dummy/'
        || lower(replace(s.display_name, ' ', '_'))
        || '/interaction_'
        || s.sequence_no
        || '.txt'

WHERE NOT EXISTS (
    SELECT 1
    FROM predictions existing
    WHERE existing.interaction_id = i.interaction_id
);


COMMIT;