"""Print how the Kokoro voice will pronounce words, after the project's respellings.

    uv run python pronounce.py "etcd" "SGLang" "KV cache"

Run from the project directory. Compare the phonemes with how the word should sound, then
add a respelling to PRONUNCIATIONS in explainer/voice.py and check it again.
"""

import sys

sys.path.insert(0, ".")
from explainer.voice import kokoro_pipeline, speakable  # noqa: E402

pipeline = kokoro_pipeline()
for word in sys.argv[1:]:
    spoken = speakable(word)
    result = next(iter(pipeline(spoken, voice="af_heart")))
    note = f" (respelled: {spoken})" if spoken != word else ""
    print(f"{word:24s} {result.phonemes}{note}")
