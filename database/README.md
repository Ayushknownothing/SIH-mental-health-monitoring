# SIH Mental Health Monitoring System — Database

## Overview

This directory contains the PostgreSQL database layer for the SIH Mental Health Monitoring System.

The database stores:

* Victim records
* Interaction records
* Emotion-analysis results
* Distress predictions
* Longitudinal assessment history

The current project prototype is primarily **text-based**. The schema also contains optional `voice_reference` fields, and the demonstration data includes synthetic audio-reference paths. These references are metadata only and do not represent required voice-processing functionality.

---

## Database Architecture

The database consists of four primary tables:

```text
victims
   │
   └──< interactions
             │
             ├──< emotion_results
             │
             └──< predictions
```

### `victims`

Stores the primary record for each monitored individual.

### `interactions`

Stores individual interactions associated with a victim.

An interaction contains:

* Timestamp
* Text response
* Optional voice reference
* Optional metadata

### `emotion_results`

Stores emotion-analysis results associated with an interaction.

The schema stores the following emotion-related values:

* Fear
* Sadness
* Anger
* Nervousness
* Voice stress

### `predictions`

Stores the distress/risk assessment associated with an interaction.

Prediction records contain:

* Distress score
* Risk level
* Confidence
* Trend direction
* Previous score
* Score change
* Model version

---

# SQL Files

## `001_initial_schema.sql`

Creates the database structure.

It defines:

* Tables
* Primary keys
* Foreign keys
* `NOT NULL` constraints
* `UNIQUE` constraints
* `CHECK` constraints
* Indexes
* Row Level Security
* Historical-data protection triggers

This file should be executed first on a fresh database.

---

## `longitudinal.sql`

Contains queries for retrieving longitudinal information for a victim.

The queries provide information including:

* Complete distress history
* Latest prediction
* Recent interactions
* Emotion history
* Risk distribution
* Interaction counts

These queries are intended to support backend and dashboard/reporting requirements.

This file contains retrieval queries and does not create or modify the database schema.

---

## `dummy_data.sql`

Loads synthetic demonstration data.

The current demonstration contains one synthetic victim and five historical interactions.

The interaction records contain text responses and synthetic `voice_reference` paths. The voice references are optional schema fields and are included in the demo as example metadata.

The demonstration distress progression is:

```text
35 → 43 → 56 → 68 → 74
```

The corresponding demonstration risk levels are:

```text
35 → MODERATE
43 → MODERATE
56 → HIGH
68 → HIGH
74 → HIGH
```

The demo dataset is intended for development, testing, and demonstration.

It must not be treated as real patient or field data.

---

## `database_tests.sql`

Verifies database structure, integrity, demo data, and protection mechanisms.

The current test file checks:

* Required tables
* Demo row counts
* Victim/interactions relationships
* Distress-score ranges
* Emotion-value ranges
* Confidence ranges
* Risk-level values
* Trend-direction values
* Duplicate emotion-result detection
* Duplicate prediction detection
* Foreign-key integrity
* Text-response presence in demo interactions
* Row Level Security status
* Historical-protection trigger presence
* Longitudinal data
* Latest prediction information

The file also contains a section of **manual rejection tests** for deliberately attempting invalid database operations.

These tests are intended to verify that PostgreSQL rejects invalid values, invalid references, duplicate records, and historical modifications.

---

# Execution Order

For a fresh PostgreSQL/Supabase database, execute the files in this order:

```text
1. 001_initial_schema.sql
2. dummy_data.sql
```

`longitudinal.sql` contains retrieval queries and can be run after the schema and demonstration data have been created.

---

# Supabase Setup

The database uses PostgreSQL and is intended to run with Supabase.

For a fresh project:

1. Open the project's Supabase SQL Editor.
2. Run `001_initial_schema.sql`.
3. Confirm that the tables and database objects are created.
4. Run `dummy_data.sql`.
5. Review the test output.
6. Run the required queries from `longitudinal.sql` when validating historical data or integrating the backend/dashboard.

The schema should be established before loading demonstration data.

---

# Verification

After running the schema and demo, `database_tests.sql` should report the expected demonstration dataset.

Expected row counts:

```text
Victims:          1
Interactions:     5
Emotion results:  5
Predictions:      5
```

Expected distress progression:

```text
35 → 43 → 56 → 68 → 74
```

Expected risk progression:

```text
MODERATE → MODERATE → HIGH → HIGH → HIGH
```

The longitudinal queries can then be used to retrieve the historical progression for `Victim 001`.

---

# Data Integrity

The database uses PostgreSQL constraints to prevent invalid data from being stored.

Important constraints include:

### Distress score

```text
0–100
```

### Emotion values

```text
0–1
```

### Confidence

```text
0–1
```

### Risk level

The schema restricts risk levels to:

```text
LOW
MODERATE
HIGH
CRITICAL
```

### Trend direction

The schema permits:

```text
INCREASING
DECREASING
STABLE
NO_PREVIOUS_DATA
```

Foreign keys prevent records from referencing nonexistent parent records.

Unique constraints prevent duplicate emotion results or predictions for the same interaction.

These protections provide a database-level integrity boundary in addition to application-level validation.

---

# Historical Data Protection

The system is designed around longitudinal records.

Historical interaction, emotion-result, and prediction records are protected against modification and deletion by database triggers.

The protection triggers reject attempts to update or delete existing historical records.

This prevents previously recorded interaction and assessment history from being silently altered.

---

# Row Level Security

Row Level Security (RLS) is enabled on the four primary database tables:

* `victims`
* `interactions`
* `emotion_results`
* `predictions`

RLS provides a PostgreSQL-level mechanism for restricting row access.

The application/backend must use appropriate authentication, authorization, credentials, and RLS policies when accessing the database.

Enabling RLS alone does not define the complete application authorization model; access policies must be configured according to the project's deployment requirements.

---

# Fault Tolerance and Error Handling

The database is designed to reject invalid operations rather than silently accept invalid data.

Examples include:

```text
Invalid distress score
        │
        ▼
CHECK constraint
        │
        ▼
Operation rejected
```

```text
Invalid victim reference
        │
        ▼
Foreign-key constraint
        │
        ▼
Operation rejected
```

```text
Duplicate interaction result
        │
        ▼
UNIQUE constraint
        │
        ▼
Operation rejected
```

```text
Historical UPDATE/DELETE
        │
        ▼
Protection trigger
        │
        ▼
Operation rejected
```

A database error is therefore not automatically a database failure. For invalid operations, rejection is the intended behavior.

The backend is responsible for handling database errors and returning controlled responses to clients.

The backend should:

* Validate incoming user input.
* Validate required fields.
* Handle database exceptions.
* Return controlled API errors.
* Use transactions for multi-step database operations.
* Avoid leaving partially completed operations when several related records must be created together.

---

# Text-First Prototype

The current prototype primarily operates on text.

A typical interaction flow is:

```text
User text
   │
   ▼
Backend / API
   │
   ▼
Text / emotion processing
   │
   ▼
Distress prediction
   │
   ▼
Database
   │
   ├── interactions
   │
   ├── emotion_results
   │
   └── predictions
```

The database schema also supports an optional `voice_reference`.

The current demonstration data contains synthetic audio-reference paths, but the database does not require voice input for an interaction.

---

# Backend Responsibilities

The database is responsible for persistent storage and database-level integrity.

The backend is responsible for:

* Input validation
* Authentication
* Authorization
* Calling the analysis/model layer
* Handling database exceptions
* Transaction management
* API error responses
* Preparing valid database writes

For operations involving multiple related records, the backend should use an appropriate database transaction.

Conceptually:

```text
BEGIN
   │
   ├── Create interaction
   │
   ├── Create emotion result
   │
   ├── Create prediction
   │
   └── COMMIT
```

If a required operation fails:

```text
BEGIN
   │
   ├── Create interaction
   │
   ├── Create emotion result
   │
   └── Failure
        │
        ▼
     ROLLBACK
```

This prevents an incomplete multi-step operation from being treated as a successful assessment.

---

# Testing Invalid Data

The database test file includes manual rejection tests for invalid operations.

Examples include attempts to:

* Insert invalid emotion values
* Insert invalid distress scores
* Insert invalid risk levels
* Insert invalid foreign-key references
* Insert duplicate emotion results
* Insert duplicate predictions
* Update historical interactions
* Delete historical interactions
* Update historical emotion results
* Delete historical emotion results
* Update historical predictions
* Delete historical predictions

The expected result of these operations is a PostgreSQL error.

That error demonstrates that the relevant database constraint or protection mechanism is functioning.

These failure-path tests should be executed in a controlled development/test database and should not be used against production data.

---

# Longitudinal Data

The database preserves the relationship between a victim and their historical interactions.

A demonstration history can therefore be represented as:

```text
Interaction 1 → Distress 35
Interaction 2 → Distress 43
Interaction 3 → Distress 56
Interaction 4 → Distress 68
Interaction 5 → Distress 74
```

Prediction records also contain:

* Previous score
* Score change
* Trend direction
* Risk level

This allows the backend or dashboard to represent changes in distress over time.

Historical records are protected against UPDATE and DELETE operations.

---

# Development Data

The records loaded by `dummy_data.sql` are synthetic demonstration records.

They are intended for:

* Development
* Database verification
* Backend integration
* Dashboard development
* Project demonstrations

Do not use real personally identifiable information or sensitive mental-health information in the demonstration dataset.

---

# Recommended Repository Structure

```text
database/
│
├── 001_initial_schema.sql
├── longitudinal.sql
├── dummy_data.sql
└── README.md
```

---

# Quick Start

For a fresh Supabase/PostgreSQL database:

```text
1. Open the SQL Editor.
2. Run 001_initial_schema.sql.
3. Run dummy_data.sql.
4. Review the integrity and protection test results.
5. Run longitudinal.sql queries when historical data is required.
6. Connect the backend after the database layer has been verified.
```

Expected demonstration dataset:

```text
1 victim
5 interactions
5 emotion results
5 predictions
```

Expected distress progression:

```text
35 → 43 → 56 → 68 → 74
```

---

# Design Principles

The database follows these principles:

1. **Reject invalid data rather than silently storing it.**
2. **Preserve historical longitudinal records.**
3. **Enforce relationships at the database level.**
4. **Use constraints as a final data-integrity boundary.**
5. **Enable Row Level Security on primary tables.**
6. **Keep the current application workflow primarily text-based.**
7. **Keep optional voice references separate from the core text workflow.**
8. **Handle user-facing database errors in the backend.**
9. **Use transactions for multi-step writes.**
10. **Use synthetic data for development and demonstration.**
11. **Keep the database schema aligned with the intended backend workflow.**

---

# Status

The database layer consists of:

```text
001_initial_schema.sql   → Database schema
dummy_data.sql                 → Synthetic demonstration data
longitudinal.sql         → Longitudinal retrieval queries
README.md                → Database documentation

```
```
