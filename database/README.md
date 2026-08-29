# SIH II — Database

## Overview

This directory contains the database layer for the SIH II Mental Health Monitoring System.

The database provides the persistent relational data model, database-level integrity constraints, historical-record protection, Row Level Security (RLS), and synthetic development data required by the current prototype.

The database is designed around longitudinal interaction records. Each victim can have multiple historical interactions, with each interaction associated with an emotion-analysis result and a distress prediction.

All development data currently stored in the database is synthetic.

## Database Structure

The database consists of four primary tables:

```text
victims
   │
   └── interactions
          │
          ├── emotion_results
          │
          └── predictions
```

### `victims`

Stores the identity-independent display information for each monitored victim.

Key fields include:

- `victim_id`
- `display_name`
- `created_at`

### `interactions`

Stores historical interactions associated with a victim.

Key fields include:

- `interaction_id`
- `victim_id`
- `timestamp`
- `text_response`
- `voice_reference`
- `created_at`

Interactions are treated as historical records and are protected against modification and deletion at the database level.

### `emotion_results`

Stores the output of the emotion-analysis stage for an interaction.

The current schema supports:

- `input_type`
- `text`
- `anger`
- `contempt`
- `disgust`
- `fear`
- `frustration`
- `gratitude`
- `joy`
- `love`
- `neutral`
- `sadness`
- `surprise`
- `voice_stress`

For text-based model outputs:

```text
input_type = text
voice_stress = NULL
```

The emotion probabilities are stored individually to support structured querying and longitudinal analysis.

### `predictions`

Stores the distress and risk assessment associated with an interaction.

Key fields include:

- `distress_score`
- `risk_level`
- `confidence`
- `trend_direction`
- `previous_score`
- `score_change`
- `model_version`
- `created_at`

Predictions are treated as historical records and are protected against modification and deletion at the database level.

## Files

```text
database/
├── 001_initial_schema.sql
├── dummy_data.sql
├── longitudinal.sql
└── README.md
```

### `001_initial_schema.sql`

Defines the database schema, including:

- Tables
- Primary keys
- Foreign keys
- Constraints
- Indexes
- Historical-record protection triggers
- Row Level Security configuration
- Required database functions and triggers

### `dummy_data.sql`

Populates the database with synthetic development data.

Current dataset:

```text
9 synthetic victims
54 interactions
54 emotion results
54 predictions
```

Each victim has:

```text
6 interactions
6 emotion results
6 predictions
```

The synthetic dataset contains longitudinal patterns including increasing, decreasing, stable, recovering, persistent, and fluctuating distress.

The data is intended for development, integration, demonstration, and validation only.

### `longitudinal.sql`

Contains queries for retrieving and analysing longitudinal victim data.

These queries support inspection of:

- Historical interactions
- Emotion results
- Distress predictions
- Risk levels
- Previous prediction scores
- Score changes
- Trend direction

## Emotion Model Data

The current emotion-analysis structure supports 11 emotion probabilities:

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

Example model output:

```python
{
    "input_type": "text",
    "text": "I feel scared and I don't feel safe.",
    "emotions": {
        "anger": 0.002836,
        "contempt": 0.001232,
        "disgust": 0.006873,
        "fear": 0.997204,
        "frustration": 0.005913,
        "gratitude": 0.001131,
        "joy": 0.001351,
        "love": 0.002697,
        "neutral": 0.007812,
        "sadness": 0.042881,
        "surprise": 0.002441
    }
}
```

The database stores these values as structured fields in `emotion_results`.

## Historical Data Protection

The database enforces append-only behaviour for historical interactions and predictions.

The following operations are intentionally blocked:

```text
interactions
    UPDATE  → blocked
    DELETE  → blocked

predictions
    UPDATE  → blocked
    DELETE  → blocked
```

Database triggers raise an exception when a historical record is modified or deleted.

This prevents previously generated interaction and prediction history from being silently altered.

New records should be created as new historical records rather than modifying existing records.

## Row Level Security

Row Level Security (RLS) is enabled on:

- `victims`
- `interactions`
- `emotion_results`
- `predictions`

The current development configuration provides the `anon` role with:

```text
SELECT  → allowed
INSERT  → allowed
UPDATE  → not allowed
DELETE  → not allowed
```

These are temporary development policies intended for the current prototype environment.

The production authentication and authorization model should be implemented before deployment with real users or sensitive data.

## Database Validation

Database testing and validation have been completed against the current schema and development dataset.

The validation covered:

- RLS enabled on all four tables
- RLS policy configuration
- Anonymous `SELECT` access
- Anonymous `INSERT` access
- Historical interaction `UPDATE` protection
- Historical interaction `DELETE` protection
- Historical prediction `UPDATE` protection
- Historical prediction `DELETE` protection
- Preservation of historical records after blocked mutation attempts
- Relational consistency between victims, interactions, emotion results, and predictions
- Longitudinal data consistency

The final relational consistency check confirmed that all 9 synthetic victims have:

```text
6 interactions
6 emotion results
6 predictions
```

The final database counts are:

```text
Victims          = 9
Interactions     = 54
Emotion Results  = 54
Predictions     = 54
```

The database layer has passed the current development validation.

## Supabase Development Environment

The current prototype uses Supabase as the PostgreSQL database backend.

The development database currently contains synthetic data only.

The current temporary access model allows the backend to connect using the Supabase anonymous key without requiring Supabase Auth.

Before production deployment, the access model should be hardened with appropriate authentication and authorization controls.

## Data Flow

The intended database-level flow is:

```text
Victim
   │
   ▼
Interaction
   │
   ├──────────────► Emotion Result
   │
   └──────────────► Prediction
```

For longitudinal analysis:

```text
Victim
   │
   ├── Interaction 1
   │      ├── Emotion Result
   │      └── Prediction
   │
   ├── Interaction 2
   │      ├── Emotion Result
   │      └── Prediction
   │
   ├── Interaction 3
   │      ├── Emotion Result
   │      └── Prediction
   │
   └── ...
```

Prediction records can reference the previous distress score and score change to support longitudinal trend analysis.

## Development Notes

The database is currently intended to support the prototype backend and ML integration.

The database layer does not itself perform:

- Input validation at the API layer
- Authentication
- Application-level authorization
- ML inference
- Model selection
- API request handling
- Application-level transaction orchestration

These responsibilities belong to the backend/application layer.

The database provides the persistent storage and database-level integrity mechanisms required by those components.

---

## Current Status

```text
Database schema              COMPLETE
Emotion schema update        COMPLETE
Synthetic dummy data         COMPLETE
RLS configuration            COMPLETE
Historical protection        COMPLETE
Database validation          COMPLETE
Longitudinal structure       COMPLETE
Supabase population          COMPLETE
```

The database layer is ready for integration with the backend and ML components.

---

## Important

All data currently used for development and demonstration is synthetic.

No real victim or patient data should be inserted into this development database.

Production deployment requires a separate security, authentication, authorization, privacy, and data-governance configuration.