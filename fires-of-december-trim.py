# /// script
# requires-python = ">=3.10"
# dependencies = ["faster-whisper", "numpy"]
# ///
import difflib
import json
import os
import re
import subprocess
import sys

import numpy as np
from faster_whisper import WhisperModel

NUMBERS = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
OUTRO_WINDOW = 600
MARGIN = 0.5


def pcm(path, start, length):
    cmd = ["ffmpeg", "-v", "error", "-ss", str(start), "-t", str(length), "-i", path,
           "-ac", "1", "-ar", "16000", "-f", "f32le", "-"]
    return np.frombuffer(subprocess.run(cmd, capture_output=True, check=True).stdout, np.float32)


def duration(path):
    cmd = ["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", path]
    return float(subprocess.run(cmd, capture_output=True, check=True, text=True).stdout)


def norm(word):
    return re.sub(r"[^a-z0-9]", "", word.lower())


def last_words(pdf, count=12):
    text = subprocess.run(["pdftotext", pdf, "-"], capture_output=True, check=True, text=True).stdout
    words = [norm(w) for w in text.replace("!", "f").replace("&", "y").split()]
    words = [w for w in words if w and not w.isdigit()]
    return words[-count:]


def narration_start(model, path, chapter):
    heading = re.compile(rf"^\W*(part \w+\W+)?chapter ({NUMBERS[chapter]}|{chapter})\b", re.I)
    for length in (60, 180, 300):
        segments, _ = model.transcribe(pcm(path, 0, length), word_timestamps=True, vad_filter=True)
        for s in segments:
            text = s.text.strip()
            if re.search(r"dragon ?steel presents", text, re.I) or heading.match(text):
                return max(0, s.words[0].start - MARGIN), text
    sys.exit(f"No opening found in {path}")


def narration_end(model, path, pdf):
    total = duration(path)
    offset = max(0, total - OUTRO_WINDOW)
    segments, _ = model.transcribe(pcm(path, offset, OUTRO_WINDOW), word_timestamps=True, vad_filter=True)
    words = [w for s in segments for w in s.words if norm(w.word)]
    spoken, target = [norm(w.word) for w in words], last_words(pdf)
    n = len(target)
    scores = [difflib.SequenceMatcher(None, spoken[i:i + n], target).ratio() for i in range(len(spoken) - n + 1)]
    best = max(range(len(scores)), key=scores.__getitem__)
    if scores[best] < 0.6:
        sys.exit(f"Closing words not found in {path} (best {scores[best]:.2f})")
    end = min(total, offset + words[best + n - 1].end + MARGIN)
    return end, "".join(w.word for w in words[best:best + n]).strip()


def main():
    path, pdf, chapter = sys.argv[1], sys.argv[2], int(sys.argv[3])
    model = WhisperModel(os.environ.get("WHISPER_MODEL", "small.en"), compute_type="int8")
    start, opening = narration_start(model, path, chapter)
    end, closing = narration_end(model, path, pdf)
    json.dump({"start": round(start, 2), "end": round(end, 2), "opening": opening, "closing": closing}, sys.stdout)


if __name__ == "__main__":
    main()
