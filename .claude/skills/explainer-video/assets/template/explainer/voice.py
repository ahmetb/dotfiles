"""Pick the narration voice from the VOICE environment variable.

VOICE=kokoro  (default) Kokoro-82M `af_heart`, a local open model; nothing leaves the machine.
VOICE=say     macOS `say`, offline and instant; for quick timing drafts only.
VOICE=record  your microphone, prompted line by line during rendering
              (needs `brew install portaudio` and `uv pip install "manim-voiceover[recorder]"`).
"""

import os
import re
import subprocess
from pathlib import Path

from manim_voiceover.services.base import SpeechService

# Spoken respellings, applied only to synthesis; on-screen text and subtitles keep the originals.
# Check new terms with the skill's pronounce.py and add any the voice gets wrong.
PRONUNCIATIONS = {
    "etcd": "et see dee",
    "Baseten": "Base ten",
    "key-value": "key value",
    "try-finally": "try finally",
}

SENTENCE_PAUSE = 0.28  # seconds of silence between sentences within a beat
BEAT_TAIL = 0.45  # silence after each beat, so consecutive beats don't run together
SAMPLE_RATE = 24000


def speakable(text):
    for written, spoken in PRONUNCIATIONS.items():
        text = re.sub(rf"\b{re.escape(written)}\b", spoken, text)
    return text


def _shorten_espeak_path():
    """espeak-ng, Kokoro's fallback for unknown words, fails on data paths over ~160 characters.

    When the virtualenv path is long, copy the data (about 19 MB, once) to a short path.
    A symlink does not work: espeak resolves it back to the long path.
    """
    import hashlib
    import shutil

    import espeakng_loader
    import misaki.espeak  # noqa: F401  sets the default (long) path at import
    from phonemizer.backend.espeak.wrapper import EspeakWrapper

    data = Path(espeakng_loader.get_data_path())
    if len(str(data)) <= 100:
        return
    tag = hashlib.sha256(str(data).encode()).hexdigest()[:8]
    short = Path("/tmp") / f"espeak-ng-data-{os.getuid()}-{tag}"  # not $TMPDIR, which can be long
    if not (short / "phontab").exists():
        partial = short.with_suffix(".partial")
        shutil.rmtree(partial, ignore_errors=True)
        shutil.copytree(data, partial)
        partial.rename(short)
    EspeakWrapper.set_data_path(str(short))


def kokoro_pipeline():
    from kokoro import KPipeline

    _shorten_espeak_path()  # must run before the pipeline builds its espeak backend
    return KPipeline(lang_code="a", repo_id="hexgrad/Kokoro-82M")


class KokoroService(SpeechService):
    """Local Kokoro-82M narration. Synthesises sentence by sentence and inserts pauses."""

    def __init__(self, voice="af_heart", speed=0.95, **kwargs):
        self.voice, self.speed, self._pipeline = voice, speed, None
        super().__init__(**kwargs)

    def generate_from_text(self, text, cache_dir=None, path=None, **kwargs):
        cache_dir = Path(cache_dir or self.cache_dir)
        spoken = speakable(text)
        input_data = {"input_text": text, "spoken": spoken, "service": "kokoro", "voice": self.voice,
                      "speed": self.speed, "pause": SENTENCE_PAUSE, "tail": BEAT_TAIL}
        cached = self.get_cached_result(input_data, cache_dir)
        if cached is not None:
            return cached
        import numpy as np
        import soundfile

        if self._pipeline is None:
            self._pipeline = kokoro_pipeline()
        gap = np.zeros(int(SENTENCE_PAUSE * SAMPLE_RATE), dtype=np.float32)
        pieces = []
        for _, _, chunk in self._pipeline(spoken, voice=self.voice, speed=self.speed,
                                          split_pattern=r"(?<=[.!?:])\s+"):
            pieces += [np.asarray(chunk, dtype=np.float32), gap]
        pieces[-1] = np.zeros(int(BEAT_TAIL * SAMPLE_RATE), dtype=np.float32)
        name = path or self.get_audio_basename(input_data) + ".wav"
        soundfile.write(cache_dir / name, np.concatenate(pieces), SAMPLE_RATE, subtype="PCM_16")
        return {"input_text": text, "input_data": input_data, "original_audio": str(name)}


class SayService(SpeechService):
    """Offline draft voice using macOS `say`, written as WAV so no ffmpeg is needed."""

    def __init__(self, voice="Samantha", rate=150, **kwargs):
        self.voice, self.rate = voice, rate
        super().__init__(**kwargs)

    def generate_from_text(self, text, cache_dir=None, path=None, **kwargs):
        cache_dir = Path(cache_dir or self.cache_dir)
        input_data = {"input_text": text, "service": "say", "voice": self.voice, "rate": self.rate}
        cached = self.get_cached_result(input_data, cache_dir)
        if cached is not None:
            return cached
        audio = path or self.get_audio_basename(input_data) + ".wav"
        subprocess.run(
            ["say", "-v", self.voice, "-r", str(self.rate), "--data-format=LEI16@22050",
             "-o", str(cache_dir / audio), speakable(text)],
            check=True,
        )
        return {"input_text": text, "input_data": input_data, "original_audio": str(audio)}


def speech_service():
    choice = os.environ.get("VOICE", "kokoro")
    if choice == "kokoro":
        return KokoroService()
    if choice == "say":
        return SayService()
    if choice == "record":
        from manim_voiceover.services.recorder import RecorderService

        return RecorderService()
    raise ValueError(f"Unknown VOICE={choice!r}; use 'kokoro', 'say' or 'record'")
