"""Check a rendered video's audio for gaps, overlaps, clipping and pacing.

    uv run python audio_check.py <video.mp4> [more.mp4 ...]

Reports, per file: duration, audio timestamp discontinuities (e.g. silence at scene joins),
peak level and clipped share, and the longest silent stretch. Run from the project directory.
"""

import sys

import av
import numpy as np


def check(path):
    container = av.open(path)
    stream = container.streams.audio[0]
    end, jumps, samples = None, [], []
    for frame in container.decode(stream):
        start = float(frame.pts * stream.time_base)
        if end is not None and abs(start - end) > 0.002:
            jumps.append((round(end, 2), round(start - end, 3)))
        end = start + frame.samples / frame.sample_rate
        samples.append(frame.to_ndarray()[0])
    x = np.concatenate(samples)
    rate = stream.codec_context.sample_rate
    hop = rate // 100
    envelope = np.abs(x[: len(x) // hop * hop]).reshape(-1, hop).mean(1)
    silent, longest, run, at = envelope < 0.005, 0, 0, 0
    for i, quiet in enumerate(silent):
        run = run + 1 if quiet else 0
        if run > longest:
            longest, at = run, i - run + 1
    print(f"{path}: {container.duration / 1e6:.1f}s")
    print(f"  timestamp discontinuities: {len(jumps)} {jumps[:10]}")
    print(f"  peak {np.abs(x).max():.3f}, clipped {np.mean(np.abs(x) > 0.999) * 100:.3f}%")
    print(f"  longest silence {longest / 100:.2f}s at {at / 100:.1f}s")


if __name__ == "__main__":
    for path in sys.argv[1:]:
        check(path)
