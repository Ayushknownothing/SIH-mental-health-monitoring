-- ============================================================
-- SIH Mental Health Monitoring System
-- Synthetic Development Data
-- ============================================================
--
-- Purpose:
-- Populate the database with synthetic text-based longitudinal
-- data matching the current database schema and emotion-model
-- output structure.
--
-- Dataset:
--   9 synthetic victims
--   54 interactions
--   54 emotion results
--   54 predictions
--
-- All data is synthetic and intended only for development,
-- testing, and demonstration.
--
-- ============================================================


BEGIN;


-- ============================================================
-- 1. Synthetic Victims
-- ============================================================

INSERT INTO victims (display_name)
VALUES
    ('Victim 001'),
    ('Victim 002'),
    ('Victim 003'),
    ('Victim 004'),
    ('Victim 005'),
    ('Victim 006'),
    ('Victim 007'),
    ('Victim 008'),
    ('Victim 009');


-- ============================================================
-- 2. Seed Data
-- ============================================================
--
-- Each row represents one historical interaction and its
-- corresponding synthetic model outputs.
--
-- The emotion fields match the current model output:
--
-- anger
-- contempt
-- disgust
-- fear
-- frustration
-- gratitude
-- joy
-- love
-- neutral
-- sadness
-- surprise
--
-- input_type = text
-- voice_stress = NULL
--
-- ============================================================

CREATE TEMP TABLE seed_data (
    display_name TEXT NOT NULL,
    sequence_no INTEGER NOT NULL,
    text_response TEXT NOT NULL,

    distress_score REAL NOT NULL,

    anger REAL NOT NULL,
    contempt REAL NOT NULL,
    disgust REAL NOT NULL,
    fear REAL NOT NULL,
    frustration REAL NOT NULL,
    gratitude REAL NOT NULL,
    joy REAL NOT NULL,
    love REAL NOT NULL,
    neutral REAL NOT NULL,
    sadness REAL NOT NULL,
    surprise REAL NOT NULL,

    PRIMARY KEY (display_name, sequence_no)
) ON COMMIT DROP;


INSERT INTO seed_data (
    display_name,
    sequence_no,
    text_response,
    distress_score,
    anger,
    contempt,
    disgust,
    fear,
    frustration,
    gratitude,
    joy,
    love,
    neutral,
    sadness,
    surprise
)
VALUES

-- ============================================================
-- Victim 001 — Increasing distress
-- ============================================================

(
    'Victim 001', 1,
    'I feel relatively calm today.',
    35.0,
    0.0020, 0.0010, 0.0030, 0.1800, 0.0100,
    0.0150, 0.1200, 0.0200, 0.6200, 0.0800, 0.0100
),
(
    'Victim 001', 2,
    'I have been feeling a little more worried lately.',
    43.0,
    0.0040, 0.0010, 0.0040, 0.2800, 0.0200,
    0.0120, 0.0900, 0.0180, 0.5400, 0.1100, 0.0120
),
(
    'Victim 001', 3,
    'Things have started to feel more difficult.',
    56.0,
    0.0080, 0.0020, 0.0060, 0.4600, 0.0350,
    0.0080, 0.0550, 0.0140, 0.4000, 0.2000, 0.0150
),
(
    'Victim 001', 4,
    'I am finding it harder to manage my stress.',
    68.0,
    0.0150, 0.0030, 0.0090, 0.6500, 0.0550,
    0.0050, 0.0300, 0.0100, 0.2800, 0.3000, 0.0120
),
(
    'Victim 001', 5,
    'I feel increasingly overwhelmed.',
    74.0,
    0.0220, 0.0040, 0.0120, 0.7900, 0.0700,
    0.0030, 0.0200, 0.0080, 0.1900, 0.3800, 0.0100
),
(
    'Victim 001', 6,
    'I am experiencing a high level of distress.',
    82.0,
    0.0300, 0.0060, 0.0180, 0.9000, 0.0850,
    0.0020, 0.0120, 0.0060, 0.1200, 0.4500, 0.0080
),


-- ============================================================
-- Victim 002 — Decreasing distress
-- ============================================================

(
    'Victim 002', 1,
    'I am feeling very overwhelmed right now.',
    82.0,
    0.0300, 0.0060, 0.0180, 0.9000, 0.0850,
    0.0020, 0.0120, 0.0060, 0.1200, 0.4500, 0.0080
),
(
    'Victim 002', 2,
    'I am still struggling but things feel slightly better.',
    72.0,
    0.0240, 0.0050, 0.0150, 0.7600, 0.0700,
    0.0030, 0.0200, 0.0080, 0.1800, 0.3900, 0.0100
),
(
    'Victim 002', 3,
    'I feel somewhat more in control today.',
    61.0,
    0.0180, 0.0040, 0.0120, 0.6100, 0.0550,
    0.0050, 0.0350, 0.0110, 0.2600, 0.3100, 0.0120
),
(
    'Victim 002', 4,
    'My stress has started to decrease.',
    49.0,
    0.0120, 0.0030, 0.0090, 0.4700, 0.0400,
    0.0070, 0.0500, 0.0140, 0.3500, 0.2300, 0.0140
),
(
    'Victim 002', 5,
    'I am feeling more settled today.',
    37.0,
    0.0070, 0.0020, 0.0060, 0.3300, 0.0250,
    0.0100, 0.0750, 0.0180, 0.4700, 0.1600, 0.0160
),
(
    'Victim 002', 6,
    'I feel relatively calm now.',
    25.0,
    0.0030, 0.0010, 0.0030, 0.2100, 0.0150,
    0.0140, 0.1100, 0.0220, 0.6100, 0.0900, 0.0180
),


-- ============================================================
-- Victim 003 — Stable distress
-- ============================================================

(
    'Victim 003', 1,
    'I feel a little worried today.',
    41.0,
    0.0080, 0.0020, 0.0060, 0.3400, 0.0300,
    0.0080, 0.0550, 0.0140, 0.4700, 0.1900, 0.0120
),
(
    'Victim 003', 2,
    'Things feel about the same today.',
    42.0,
    0.0080, 0.0020, 0.0060, 0.3500, 0.0310,
    0.0080, 0.0540, 0.0140, 0.4600, 0.1950, 0.0120
),
(
    'Victim 003', 3,
    'I am managing things reasonably well.',
    40.0,
    0.0070, 0.0020, 0.0050, 0.3300, 0.0290,
    0.0090, 0.0580, 0.0150, 0.4800, 0.1800, 0.0130
),
(
    'Victim 003', 4,
    'I still feel somewhat unsettled.',
    43.0,
    0.0090, 0.0020, 0.0070, 0.3600, 0.0320,
    0.0070, 0.0520, 0.0130, 0.4500, 0.2000, 0.0120
),
(
    'Victim 003', 5,
    'There has not been much change.',
    41.0,
    0.0080, 0.0020, 0.0060, 0.3450, 0.0300,
    0.0080, 0.0550, 0.0140, 0.4650, 0.1900, 0.0120
),
(
    'Victim 003', 6,
    'I feel about the same as before.',
    42.0,
    0.0080, 0.0020, 0.0060, 0.3500, 0.0310,
    0.0080, 0.0540, 0.0140, 0.4600, 0.1950, 0.0120
),


-- ============================================================
-- Victim 004 — Increasing distress
-- ============================================================

(
    'Victim 004', 1,
    'I am feeling calm today.',
    18.0,
    0.0020, 0.0010, 0.0020, 0.1000, 0.0080,
    0.0200, 0.1800, 0.0300, 0.6500, 0.0600, 0.0120
),
(
    'Victim 004', 2,
    'I have some concerns on my mind.',
    29.0,
    0.0040, 0.0010, 0.0040, 0.2200, 0.0150,
    0.0150, 0.1200, 0.0220, 0.5600, 0.0900, 0.0130
),
(
    'Victim 004', 3,
    'I have been feeling more worried lately.',
    42.0,
    0.0080, 0.0020, 0.0060, 0.3600, 0.0300,
    0.0100, 0.0750, 0.0160, 0.4500, 0.1500, 0.0140
),
(
    'Victim 004', 4,
    'I am having difficulty managing my stress.',
    55.0,
    0.0150, 0.0030, 0.0100, 0.5100, 0.0450,
    0.0060, 0.0450, 0.0120, 0.3400, 0.2400, 0.0130
),
(
    'Victim 004', 5,
    'I feel increasingly overwhelmed.',
    68.0,
    0.0220, 0.0040, 0.0140, 0.6800, 0.0600,
    0.0040, 0.0250, 0.0090, 0.2300, 0.3400, 0.0110
),
(
    'Victim 004', 6,
    'I am experiencing a very high level of distress.',
    80.0,
    0.0300, 0.0060, 0.0180, 0.8800, 0.0800,
    0.0020, 0.0120, 0.0060, 0.1300, 0.4400, 0.0080
),


-- ============================================================
-- Victim 005 — Recovery
-- ============================================================

(
    'Victim 005', 1,
    'I am feeling extremely overwhelmed today.',
    86.0,
    0.0350, 0.0070, 0.0200, 0.9500, 0.0900,
    0.0010, 0.0080, 0.0040, 0.0800, 0.5200, 0.0060
),
(
    'Victim 005', 2,
    'Things are still difficult but slightly better.',
    76.0,
    0.0270, 0.0050, 0.0160, 0.8100, 0.0750,
    0.0020, 0.0150, 0.0060, 0.1500, 0.4300, 0.0080
),
(
    'Victim 005', 3,
    'I feel somewhat less overwhelmed today.',
    64.0,
    0.0200, 0.0040, 0.0120, 0.6700, 0.0600,
    0.0040, 0.0250, 0.0090, 0.2300, 0.3400, 0.0100
),
(
    'Victim 005', 4,
    'My stress seems to be coming down.',
    51.0,
    0.0140, 0.0030, 0.0090, 0.5200, 0.0450,
    0.0060, 0.0400, 0.0120, 0.3300, 0.2600, 0.0120
),
(
    'Victim 005', 5,
    'I am feeling more settled.',
    38.0,
    0.0080, 0.0020, 0.0060, 0.3600, 0.0300,
    0.0090, 0.0650, 0.0160, 0.4400, 0.1800, 0.0140
),
(
    'Victim 005', 6,
    'I feel much calmer today.',
    27.0,
    0.0040, 0.0010, 0.0040, 0.2400, 0.0180,
    0.0140, 0.1050, 0.0220, 0.5700, 0.1000, 0.0160
),


-- ============================================================
-- Victim 006 — Persistent high distress
-- ============================================================

(
    'Victim 006', 1,
    'I am under a lot of pressure today.',
    79.0,
    0.0280, 0.0050, 0.0160, 0.8500, 0.0800,
    0.0020, 0.0100, 0.0050, 0.1100, 0.4600, 0.0070
),
(
    'Victim 006', 2,
    'The pressure has continued.',
    82.0,
    0.0300, 0.0060, 0.0180, 0.8800, 0.0850,
    0.0020, 0.0090, 0.0050, 0.1000, 0.4800, 0.0070
),
(
    'Victim 006', 3,
    'I am finding things very difficult to manage.',
    88.0,
    0.0340, 0.0070, 0.0200, 0.9300, 0.0950,
    0.0010, 0.0070, 0.0040, 0.0800, 0.5200, 0.0060
),
(
    'Victim 006', 4,
    'I feel extremely overwhelmed.',
    91.0,
    0.0380, 0.0080, 0.0220, 0.9700, 0.1000,
    0.0010, 0.0050, 0.0030, 0.0600, 0.5500, 0.0050
),
(
    'Victim 006', 5,
    'I am still experiencing significant distress.',
    87.0,
    0.0330, 0.0070, 0.0190, 0.9200, 0.0900,
    0.0010, 0.0070, 0.0040, 0.0800, 0.5100, 0.0060
),
(
    'Victim 006', 6,
    'I continue to feel extremely overwhelmed.',
    93.0,
    0.0400, 0.0090, 0.0240, 0.9800, 0.1050,
    0.0010, 0.0040, 0.0030, 0.0500, 0.5700, 0.0040
),


-- ============================================================
-- Victim 007 — Fluctuating distress
-- ============================================================

(
    'Victim 007', 1,
    'I have some things worrying me today.',
    31.0,
    0.0050, 0.0010, 0.0040, 0.2500, 0.0200,
    0.0120, 0.0900, 0.0200, 0.5200, 0.1200, 0.0140
),
(
    'Victim 007', 2,
    'I am feeling more unsettled than yesterday.',
    44.0,
    0.0100, 0.0020, 0.0070, 0.4000, 0.0350,
    0.0080, 0.0600, 0.0140, 0.4100, 0.1900, 0.0130
),
(
    'Victim 007', 3,
    'I feel a little better today.',
    37.0,
    0.0070, 0.0020, 0.0050, 0.3200, 0.0250,
    0.0100, 0.0750, 0.0170, 0.4700, 0.1500, 0.0140
),
(
    'Victim 007', 4,
    'Some of the stress has returned.',
    52.0,
    0.0140, 0.0030, 0.0100, 0.5000, 0.0450,
    0.0060, 0.0450, 0.0120, 0.3400, 0.2400, 0.0130
),
(
    'Victim 007', 5,
    'I am managing but still somewhat worried.',
    45.0,
    0.0100, 0.0020, 0.0080, 0.4200, 0.0370,
    0.0080, 0.0550, 0.0140, 0.3900, 0.2000, 0.0130
),
(
    'Victim 007', 6,
    'I am feeling more stressed again.',
    58.0,
    0.0170, 0.0040, 0.0120, 0.5600, 0.0500,
    0.0050, 0.0350, 0.0100, 0.2900, 0.2700, 0.0120
),


-- ============================================================
-- Victim 008 — Recovery after high distress
-- ============================================================

(
    'Victim 008', 1,
    'I have been feeling very stressed lately.',
    71.0,
    0.0230, 0.0040, 0.0140, 0.7600, 0.0650,
    0.0030, 0.0200, 0.0080, 0.1700, 0.4000, 0.0100
),
(
    'Victim 008', 2,
    'The stress feels slightly worse today.',
    75.0,
    0.0260, 0.0050, 0.0160, 0.8100, 0.0700,
    0.0020, 0.0170, 0.0070, 0.1500, 0.4200, 0.0090
),
(
    'Victim 008', 3,
    'I am beginning to feel a little better.',
    62.0,
    0.0180, 0.0030, 0.0110, 0.6400, 0.0520,
    0.0050, 0.0300, 0.0100, 0.2400, 0.3200, 0.0120
),
(
    'Victim 008', 4,
    'Things feel somewhat more manageable.',
    50.0,
    0.0120, 0.0030, 0.0080, 0.5000, 0.0420,
    0.0070, 0.0450, 0.0130, 0.3300, 0.2500, 0.0130
),
(
    'Victim 008', 5,
    'I am feeling more settled today.',
    39.0,
    0.0080, 0.0020, 0.0060, 0.3700, 0.0300,
    0.0090, 0.0650, 0.0160, 0.4400, 0.1800, 0.0140
),
(
    'Victim 008', 6,
    'I feel considerably calmer than before.',
    30.0,
    0.0040, 0.0010, 0.0040, 0.2600, 0.0200,
    0.0130, 0.1000, 0.0210, 0.5600, 0.1100, 0.0160
),


-- ============================================================
-- Victim 009 — Stable moderate distress
-- ============================================================

(
    'Victim 009', 1,
    'I feel somewhat anxious about today.',
    47.0,
    0.0100, 0.0020, 0.0080, 0.4300, 0.0380,
    0.0070, 0.0500, 0.0130, 0.3900, 0.2100, 0.0130
),
(
    'Victim 009', 2,
    'I am still thinking about the same concerns.',
    48.0,
    0.0110, 0.0020, 0.0080, 0.4400, 0.0390,
    0.0070, 0.0490, 0.0130, 0.3800, 0.2150, 0.0130
),
(
    'Victim 009', 3,
    'I am managing, although I still feel worried.',
    46.0,
    0.0100, 0.0020, 0.0070, 0.4200, 0.0370,
    0.0080, 0.0520, 0.0140, 0.4000, 0.2000, 0.0140
),
(
    'Victim 009', 4,
    'Today feels fairly similar to yesterday.',
    47.0,
    0.0100, 0.0020, 0.0080, 0.4300, 0.0380,
    0.0070, 0.0500, 0.0130, 0.3900, 0.2100, 0.0130
),
(
    'Victim 009', 5,
    'I still have some concerns, but I am coping.',
    45.0,
    0.0090, 0.0020, 0.0070, 0.4100, 0.0350,
    0.0080, 0.0550, 0.0140, 0.4100, 0.1900, 0.0140
),
(
    'Victim 009', 6,
    'I feel about the same overall.',
    46.0,
    0.0100, 0.0020, 0.0070, 0.4200, 0.0370,
    0.0080, 0.0520, 0.0140, 0.4000, 0.2000, 0.0140
);


-- ============================================================
-- 3. Insert Interactions
-- ============================================================

INSERT INTO interactions (
    victim_id,
    timestamp,
    text_response,
    voice_reference
)
SELECT
    v.victim_id,
    NOW() - ((6 - s.sequence_no) * INTERVAL '1 day'),
    s.text_response,
    NULL
FROM seed_data s
INNER JOIN victims v
    ON v.display_name = s.display_name
ORDER BY
    v.display_name,
    s.sequence_no;


-- ============================================================
-- 4. Insert Emotion Results
-- ============================================================

INSERT INTO emotion_results (
    interaction_id,
    input_type,
    text,
    anger,
    contempt,
    disgust,
    fear,
    frustration,
    gratitude,
    joy,
    love,
    neutral,
    sadness,
    surprise,
    voice_stress
)
SELECT
    i.interaction_id,
    'text',
    s.text_response,
    s.anger,
    s.contempt,
    s.disgust,
    s.fear,
    s.frustration,
    s.gratitude,
    s.joy,
    s.love,
    s.neutral,
    s.sadness,
    s.surprise,
    NULL
FROM seed_data s
INNER JOIN victims v
    ON v.display_name = s.display_name
INNER JOIN interactions i
    ON i.victim_id = v.victim_id
   AND i.text_response = s.text_response;


-- ============================================================
-- 5. Insert Predictions
-- ============================================================

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
        WHEN s.distress_score <= 25 THEN 'LOW'
        WHEN s.distress_score <= 50 THEN 'MODERATE'
        WHEN s.distress_score <= 75 THEN 'HIGH'
        ELSE 'CRITICAL'
    END,

    CASE
        WHEN s.distress_score >= 76 THEN 0.91
        WHEN s.distress_score >= 51 THEN 0.88
        WHEN s.distress_score >= 26 THEN 0.85
        ELSE 0.82
    END,

    CASE
        WHEN s.sequence_no = 1 THEN 'NO_PREVIOUS_DATA'

        WHEN s.distress_score > previous.distress_score
            THEN 'INCREASING'

        WHEN s.distress_score < previous.distress_score
            THEN 'DECREASING'

        ELSE 'STABLE'
    END,

    previous.distress_score,

    CASE
        WHEN previous.distress_score IS NULL
            THEN NULL
        ELSE s.distress_score - previous.distress_score
    END,

    'dummy-v2'

FROM seed_data s

INNER JOIN victims v
    ON v.display_name = s.display_name

INNER JOIN interactions i
    ON i.victim_id = v.victim_id
   AND i.text_response = s.text_response

LEFT JOIN seed_data previous
    ON previous.display_name = s.display_name
   AND previous.sequence_no = s.sequence_no - 1;


-- ============================================================
-- 6. Verification
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM victims) AS victim_count,
    (SELECT COUNT(*) FROM interactions) AS interaction_count,
    (SELECT COUNT(*) FROM emotion_results) AS emotion_result_count,
    (SELECT COUNT(*) FROM predictions) AS prediction_count;


-- Expected:
--
-- victim_count        = 9
-- interaction_count   = 54
-- emotion_result_count = 54
-- prediction_count    = 54
--
-- ============================================================


COMMIT;