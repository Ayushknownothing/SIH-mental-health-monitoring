import os
import joblib
import pandas as pd


# ============================================================
# MODEL PATH
# ============================================================

MODEL_PATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "..",
        "training",
        "calibrated_distress_model.pkl"
    )
)


# ============================================================
# EMOTION FEATURES
# ============================================================

EMOTIONS = [
    "anger",
    "contempt",
    "disgust",
    "fear",
    "frustration",
    "gratitude",
    "joy",
    "love",
    "neutral",
    "sadness",
    "surprise"
]


# ============================================================
# LOAD MODEL
# ============================================================

def load_model():

    if not os.path.exists(MODEL_PATH):
        raise FileNotFoundError(
            f"Calibrated model not found at: {MODEL_PATH}"
        )

    saved_model = joblib.load(MODEL_PATH)

    model = saved_model["model"]
    feature_columns = saved_model["features"]

    return model, feature_columns


# ============================================================
# RISK LEVEL
# ============================================================

def get_risk_level(distress_score):

    if distress_score <= 25:
        return "LOW"

    elif distress_score <= 50:
        return "MODERATE"

    elif distress_score <= 75:
        return "HIGH"

    else:
        return "CRITICAL"


# ============================================================
# TREND DIRECTION
# ============================================================

def get_trend_direction(score_change):

    if score_change > 3:
        return "INCREASING"

    elif score_change < -3:
        return "DECREASING"

    else:
        return "STABLE"


# ============================================================
# MAIN DISTRESS PREDICTOR
# ============================================================

def predict_distress(
    current_emotions,
    previous_distress=None
):

    # --------------------------------------------------------
    # 1. Load calibrated model
    # --------------------------------------------------------

    model, feature_columns = load_model()


    # --------------------------------------------------------
    # 2. Prepare current emotion features
    # --------------------------------------------------------

    data = {}

    for emotion in EMOTIONS:

        data[emotion] = float(
            current_emotions.get(emotion, 0.0)
        )


    # --------------------------------------------------------
    # 3. Create model input
    # --------------------------------------------------------
    # The calibrated model was trained using ONLY the
    # 11 emotion features.
    #
    # We use the exact feature order saved with the model.

    input_data = pd.DataFrame(
        [[data[feature] for feature in feature_columns]],
        columns=feature_columns
    )


    # --------------------------------------------------------
    # 4. Predict distress
    # --------------------------------------------------------

    predicted_score = float(
        model.predict(input_data)[0]
    )


    # --------------------------------------------------------
    # 5. Keep score between 0 and 100
    # --------------------------------------------------------

    predicted_score = max(
        0.0,
        min(100.0, predicted_score)
    )


    # --------------------------------------------------------
    # 6. Calculate trend
    # --------------------------------------------------------

    if previous_distress is None:

        previous_score = None
        score_change = 0.0
        trend = "NO_PREVIOUS_DATA"

    else:

        previous_score = float(
            previous_distress
        )

        score_change = (
            predicted_score - previous_score
        )

        trend = get_trend_direction(
            score_change
        )


    # --------------------------------------------------------
    # 7. Risk level
    # --------------------------------------------------------

    risk_level = get_risk_level(
        predicted_score
    )


    # --------------------------------------------------------
    # 8. Return result
    # --------------------------------------------------------

    return {

        "distress_score": round(
            predicted_score,
            2
        ),

        "risk_level": risk_level,

        "trend_direction": trend,

        "previous_score": (
            None
            if previous_score is None
            else round(
                previous_score,
                2
            )
        ),

        "score_change": round(
            score_change,
            2
        )
    }