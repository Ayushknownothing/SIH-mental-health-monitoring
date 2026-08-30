import pandas as pd
import joblib

from sklearn.linear_model import Ridge
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import GroupShuffleSplit


DATASET_PATH = "training_dataset.csv"
MODEL_PATH = "calibrated_distress_model.pkl"


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


def main():

    print("Loading dataset...")

    df = pd.read_csv(DATASET_PATH)

    print(f"Dataset shape: {df.shape}")

    X = df[EMOTIONS]
    y = df["distress_score"]

    print(f"Features: {len(EMOTIONS)}")
    print("Target: distress_score")

    # --------------------------------------------------------
    # Split by victim
    # --------------------------------------------------------

    splitter = GroupShuffleSplit(
        n_splits=1,
        test_size=0.25,
        random_state=42
    )

    train_idx, test_idx = next(
        splitter.split(
            X,
            y,
            groups=df["display_name"]
        )
    )

    X_train = X.iloc[train_idx]
    X_test = X.iloc[test_idx]

    y_train = y.iloc[train_idx]
    y_test = y.iloc[test_idx]

    print(f"\nTraining rows: {len(X_train)}")
    print(f"Testing rows: {len(X_test)}")

    print("\nTraining victims:")
    print(df.iloc[train_idx]["display_name"].unique())

    print("\nTesting victims:")
    print(df.iloc[test_idx]["display_name"].unique())

    # --------------------------------------------------------
    # Try several Ridge regularization strengths
    # --------------------------------------------------------

    alphas = [0.01, 0.1, 1.0, 10.0, 100.0]

    best_model = None
    best_mae = float("inf")
    best_alpha = None

    print("\nTesting Ridge models...")

    for alpha in alphas:

        model = Ridge(
            alpha=alpha
        )

        model.fit(
            X_train,
            y_train
        )

        predictions = model.predict(
            X_test
        )

        predictions = predictions.clip(
            0,
            100
        )

        mae = mean_absolute_error(
            y_test,
            predictions
        )

        rmse = mean_squared_error(
            y_test,
            predictions
        ) ** 0.5

        r2 = r2_score(
            y_test,
            predictions
        )

        print(
            f"alpha={alpha:<6} "
            f"MAE={mae:.2f} "
            f"RMSE={rmse:.2f} "
            f"R2={r2:.3f}"
        )

        if mae < best_mae:

            best_mae = mae
            best_model = model
            best_alpha = alpha

    # --------------------------------------------------------
    # Evaluate best model
    # --------------------------------------------------------

    predictions = best_model.predict(
        X_test
    )

    predictions = predictions.clip(
        0,
        100
    )

    mae = mean_absolute_error(
        y_test,
        predictions
    )

    rmse = mean_squared_error(
        y_test,
        predictions
    ) ** 0.5

    r2 = r2_score(
        y_test,
        predictions
    )

    print("\nBest model")
    print("----------")

    print(f"Alpha: {best_alpha}")
    print(f"MAE  : {mae:.2f}")
    print(f"RMSE : {rmse:.2f}")
    print(f"R²   : {r2:.3f}")

    print("\nActual vs Predicted")

    for actual, predicted in zip(
        y_test,
        predictions
    ):
        print(
            f"Actual: {actual:.1f} | "
            f"Predicted: {predicted:.1f}"
        )

    # --------------------------------------------------------
    # Show coefficients
    # --------------------------------------------------------

    print("\nLearned emotion influence")

    for emotion, coefficient in zip(
        EMOTIONS,
        best_model.coef_
    ):
        print(
            f"{emotion:12s}: {coefficient:.2f}"
        )

    print(
        f"\nIntercept: {best_model.intercept_:.2f}"
    )

    # --------------------------------------------------------
    # Save model
    # --------------------------------------------------------

    joblib.dump(
        {
            "model": best_model,
            "features": EMOTIONS
        },
        MODEL_PATH
    )

    print(
        f"\nModel saved to: {MODEL_PATH}"
    )


if __name__ == "__main__":
    main()