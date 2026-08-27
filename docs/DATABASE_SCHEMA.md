# SIH Mental Health Monitoring System

## Database Schema

**Project:** AI-Powered Dynamic Mental Health Monitoring and Distress Prediction System for Victims of Atrocities

**Database:** Supabase PostgreSQL

**Version:** 1.0
**Status:** Prototype

---

# 1. Database Purpose

The database stores victim profiles, individual check-ins, emotion-analysis results, and distress predictions.

The system must preserve the complete history of assessments so that distress can be monitored longitudinally.

**Important:** Previous interactions and predictions must never be overwritten by a newer check-in.

---

# 2. Database Relationship

```text
victims
   |
   | 1 : N
   v
interactions
   |
   | 1 : 1
   +------------------> emotion_results
   |
   | 1 : 1
   +------------------> predictions
```

A single victim can have many interactions.

Each interaction produces one emotion-analysis result and one distress prediction.

---

# 3. Table: victims

Stores the minimum information required to identify a victim in the prototype.

| Column       | Type        | Constraints   | Description              |
| ------------ | ----------- | ------------- | ------------------------ |
| victim_id    | UUID        | PRIMARY KEY   | Unique victim identifier |
| display_name | TEXT        | Optional      | Display name or alias    |
| created_at   | TIMESTAMPTZ | DEFAULT now() | Record creation time     |

Example:

```text
victim_id: V001
display_name: Victim 001
```

For the prototype, unnecessary personally identifiable information should not be stored.

---

# 4. Table: interactions

Stores every check-in submitted by a victim.

| Column          | Type        | Constraints   | Description                    |
| --------------- | ----------- | ------------- | ------------------------------ |
| interaction_id  | UUID        | PRIMARY KEY   | Unique interaction identifier  |
| victim_id       | UUID        | FOREIGN KEY   | References victims.victim_id   |
| timestamp       | TIMESTAMPTZ | DEFAULT now() | Time of check-in               |
| text_response   | TEXT        | Optional      | Text submitted during check-in |
| voice_reference | TEXT        | Optional      | Reference to stored audio      |
| created_at      | TIMESTAMPTZ | DEFAULT now() | Record creation time           |

Relationship:

```text
interactions.victim_id
        ↓
victims.victim_id
```

Every check-in creates a new row.

Example:

```text
V001
 ├── Interaction A → 10:00
 ├── Interaction B → 11:00
 ├── Interaction C → 12:00
 └── Interaction D → 13:00
```

---

# 5. Table: emotion_results

Stores the numerical outputs from the text and voice analysis pipeline.

| Column            | Type        | Constraints         | Description                       |
| ----------------- | ----------- | ------------------- | --------------------------------- |
| emotion_result_id | UUID        | PRIMARY KEY         | Unique result ID                  |
| interaction_id    | UUID        | FOREIGN KEY, UNIQUE | Related interaction               |
| fear              | REAL        | 0–1                 | Fear probability/indicator        |
| sadness           | REAL        | 0–1                 | Sadness probability/indicator     |
| anger             | REAL        | 0–1                 | Anger probability/indicator       |
| nervousness       | REAL        | 0–1                 | Nervousness-related indicator     |
| voice_stress      | REAL        | 0–1                 | Normalized voice stress indicator |
| created_at        | TIMESTAMPTZ | DEFAULT now()       | Record creation time              |

The exact emotion feature set may be adjusted after testing the selected RoBERTa model.

Emotion values represent model outputs and are not clinical measurements.

---

# 6. Table: predictions

Stores the final distress prediction produced by the prototype ANN.

| Column          | Type        | Constraints         | Description                                   |
| --------------- | ----------- | ------------------- | --------------------------------------------- |
| prediction_id   | UUID        | PRIMARY KEY         | Unique prediction ID                          |
| interaction_id  | UUID        | FOREIGN KEY, UNIQUE | Related interaction                           |
| distress_score  | REAL        | 0–100               | Prototype distress score                      |
| risk_level      | TEXT        | Required            | LOW/MODERATE/HIGH/CRITICAL                    |
| confidence      | REAL        | 0–1                 | Model confidence indicator                    |
| trend_direction | TEXT        | Optional            | INCREASING/DECREASING/STABLE/NO_PREVIOUS_DATA |
| previous_score  | REAL        | Optional            | Previous distress score                       |
| score_change    | REAL        | Optional            | Current score - previous score                |
| model_version   | TEXT        | Optional            | Version of prediction model                   |
| created_at      | TIMESTAMPTZ | DEFAULT now()       | Prediction creation time                      |

---

# 7. Risk Levels

The prototype uses the following thresholds:

|  Score | Risk Level |
| -----: | ---------- |
|   0–25 | LOW        |
|  26–50 | MODERATE   |
|  51–75 | HIGH       |
| 76–100 | CRITICAL   |

These thresholds are prototype-defined and are **not clinical standards**.

---

# 8. Example Longitudinal Data

A victim may have the following history:

```text
V001
│
├── 10:00
│     Distress = 35
│     Risk = MODERATE
│
├── 11:00
│     Distress = 43
│     Risk = MODERATE
│
├── 12:00
│     Distress = 56
│     Risk = HIGH
│
├── 13:00
│     Distress = 68
│     Risk = HIGH
│
└── 14:00
      Distress = 74
      Risk = HIGH
```

The database therefore contains five separate interactions and five separate predictions.

---

# 9. Data Flow

```text
Victim Check-in
      |
      v
interactions
      |
      +--------------------+
      |                    |
      v                    v
emotion_results        AI/ANN Prediction
                           |
                           v
                      predictions
```

The backend is responsible for coordinating this process.

---

# 10. Historical Retrieval

To display the distress trend, the backend should retrieve predictions ordered by timestamp.

Conceptually:

```text
SELECT
    interaction_id,
    distress_score,
    risk_level,
    trend_direction,
    created_at
FROM predictions
WHERE interaction_id belongs to victim
ORDER BY created_at ASC;
```

The exact SQL implementation may differ depending on the backend implementation.

---

# 11. Privacy Principles

The prototype should follow data-minimization principles.

Avoid storing:

- unnecessary personal information
- unnecessary demographic information
- raw sensitive information when it is not required
- API keys
- authentication secrets

Victims should primarily be represented using unique identifiers such as:

```text
V001
V002
V003
```

Audio storage should use references rather than embedding large audio files directly inside PostgreSQL.

---

# 12. Authentication and Access Control

Supabase Authentication may be used for authorized users.

Prototype roles may include:

```text
COUNSELLOR
AUTHORITY
ADMIN
```

The exact role implementation may be simplified for the prototype.

Where practical, Supabase Row Level Security (RLS) should restrict access to sensitive records.

The prototype must not claim complete production-grade government security or legal compliance unless those controls are actually implemented and verified.

---

# 13. Database Rules

### Rule 1

Never overwrite historical predictions.

### Rule 2

Every check-in creates a new interaction.

### Rule 3

Every interaction should have its associated analysis and prediction.

### Rule 4

Use UUIDs or unique identifiers for database records.

### Rule 5

Emotion and voice values should remain normalized between `0` and `1`.

### Rule 6

Distress score should remain between `0` and `100`.

### Rule 7

Do not store secrets in the database schema or Git repository.

### Rule 8

Use Supabase PostgreSQL rather than introducing a separate local database.

### Rule 9

Keep the database schema simple enough for the SIH prototype.

### Rule 10

Historical data must remain available for longitudinal visualization.
