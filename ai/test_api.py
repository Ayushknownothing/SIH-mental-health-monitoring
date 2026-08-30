import requests
from pathlib import Path


AI_URL = "http://127.0.0.1:8001"


def test_text():

    data = {
        "text": "I feel scared and I don't feel safe."
    }

    response = requests.post(
        f"{AI_URL}/api/analyze/text",
        json=data
    )

    print("\n" + "=" * 60)
    print("TEXT API TEST")
    print("=" * 60)
    print("Status:", response.status_code)
    print("Response:")
    print(response.json())


def test_speech():

    audio_path = Path(r"D:\Downloads\test_sample4.wav")

    with open(audio_path, "rb") as audio_file:

        files = {
            "audio": (
                audio_path.name,
                audio_file,
                "audio/wav"
            )
        }

        response = requests.post(
            f"{AI_URL}/api/analyze/speech",
            files=files
        )

    print("\n" + "=" * 60)
    print("SPEECH API TEST")
    print("=" * 60)
    print("Status:", response.status_code)
    print("Response:")
    print(response.json())


if __name__ == "__main__":

    test_text()
    test_speech()