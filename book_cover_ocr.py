"""
book_cover_ocr.py  --  book cover OCR + matching for ReadNext

Same approach as book_cover_identification.ipynb:
  1. EasyOCR reads the text printed on the cover
  2. RapidFuzz compares that text with titles/authors stored in MySQL
"""
import re

import numpy as np
from PIL import Image, ImageOps
from rapidfuzz import fuzz

# ---------------------------------------------------------------------------
# OCR reader (loaded once, lazily)
# Loading EasyOCR takes several seconds, so we must NOT create it per request.
# Lazy loading also avoids loading it twice under Flask's debug reloader.
# ---------------------------------------------------------------------------
_reader = None


def get_reader():
    global _reader
    if _reader is None:
        import easyocr  # imported here so the app still starts if it's missing
        _reader = easyocr.Reader(["en"], gpu=False)  # set gpu=True if you have CUDA
    return _reader


def extract_text(file_stream, max_side=1280, min_confidence=0.3):
    """Read text from an uploaded image (file object / stream) and return it as one string."""
    img = Image.open(file_stream)
    img = ImageOps.exif_transpose(img).convert("RGB")  # fix phone-photo rotation
    img.thumbnail((max_side, max_side))                # big photos = slow OCR, no accuracy gain

    results = get_reader().readtext(np.array(img))     # [(bbox, text, confidence), ...]
    return " ".join(text for _, text, conf in results if conf >= min_confidence)


# ---------------------------------------------------------------------------
# Matching (logic taken from your notebook)
# ---------------------------------------------------------------------------
def clean_text(text):
    text = str(text or "").lower()
    text = re.sub(r"[^a-z0-9 ]", " ", text)
    return " ".join(text.split())


def find_matching_books(cursor, ocr_text, limit=5, min_score=55):
    """
    cursor must be created with dictionary=True.
    Returns up to `limit` books (best first), each with an added 'score' key.
    """
    ocr_text = clean_text(ocr_text)
    if not ocr_text:
        return []
    ocr_words = ocr_text.split()

    cursor.execute("""
        SELECT b.book_id, b.title, b.cover_image_url, a.name AS author
        FROM books b
        LEFT JOIN authors a ON b.author_id = a.author_id
    """)

    matches = []
    for book in cursor.fetchall():
        title_words = clean_text(book["title"]).split()
        if not title_words:
            continue
        author = clean_text(book["author"])

        # how well does each title word appear somewhere in the OCR text?
        word_scores = [
            max(fuzz.ratio(word, detected) for detected in ocr_words)
            for word in title_words
        ]
        title_score = sum(word_scores) / len(word_scores)
        author_score = fuzz.partial_ratio(author, ocr_text) if author else 0

        score = 0.8 * title_score + 0.2 * author_score
        if score >= min_score:
            book["score"] = round(score, 1)
            matches.append(book)

    matches.sort(key=lambda b: b["score"], reverse=True)
    return matches[:limit]
