"""
review_sentiment.py - shows positive / neutral / negative on reviews using YOUR trained ANN.

Needs these 2 files next to this file (created by train_sentiment_ann.ipynb):
    sentiment_model.keras
    count_vectorizer.pkl
Until they exist, no sentiment badges are shown (the website still works normally).
"""
import os
import re
import pickle

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
NAMES = ["negative", "neutral", "positive"]      # same order as in the notebook

# ---- load the trained model once, when the app starts ----
model = None
cv = None
try:
    from tensorflow.keras.models import load_model
    model = load_model(os.path.join(BASE_DIR, "sentiment_model.keras"))
    with open(os.path.join(BASE_DIR, "count_vectorizer.pkl"), "rb") as f:
        cv = pickle.load(f)
    print("[sentiment] model loaded")
except Exception as e:
    print("[sentiment] model not loaded - run train_sentiment_ann.ipynb and copy its 2 files here.", e)


def clean_text(text):          # must be identical to clean_text in the notebook
    text = str(text).lower().replace("’", "'")
    text = text.replace("won't", "will not").replace("can't", "can not")
    text = re.sub(r"n't\b", " not", text)
    text = re.sub(r"[^a-z ]", " ", text)
    return " ".join(text.split())


def add_sentiment(reviews):
    """
    reviews = list of review dicts from MySQL.
    Adds r["sentiment"] ("positive"/"neutral"/"negative", or None) to every review
    and returns the counts, e.g. {"positive": 3, "neutral": 1, "negative": 0}
    """
    counts = {"positive": 0, "neutral": 0, "negative": 0}
    for r in reviews:
        r["sentiment"] = None

    if model is None:
        return counts

    try:
        with_text = [r for r in reviews if (r.get("review_text") or "").strip()]
        if with_text:
            features = cv.transform([clean_text(r["review_text"]) for r in with_text]).toarray()
            predictions = model.predict(features, verbose=0).argmax(axis=1)
            for r, p in zip(with_text, predictions):
                r["sentiment"] = NAMES[int(p)]
                counts[r["sentiment"]] += 1
    except Exception as e:
        print("[sentiment] prediction failed:", e)
    return counts
