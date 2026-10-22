"""Tile frames sampled from a rendered video into one PNG for visual review.

    uv run python frame_sheet.py <video.mp4> <out.png> [fractions]

fractions: comma-separated positions in the video, e.g. 0.2,0.5,0.8,0.99 (default).
Run from the project directory so PyAV and Pillow come from its environment.
"""

import sys

import av
from PIL import Image


def sheet(video, out, fractions, width=854):
    container = av.open(video)
    duration = container.duration / 1e6
    wanted, frames = [f * duration for f in fractions], []
    for frame in container.decode(container.streams.video[0]):
        if len(frames) < len(wanted) and frame.time >= wanted[len(frames)]:
            image = frame.to_image()
            frames.append(image.resize((width, int(image.height * width / image.width))))
        if len(frames) == len(wanted):
            break
    w, h = frames[0].size
    rows = (len(frames) + 1) // 2
    canvas = Image.new("RGB", (w * 2, h * rows))
    for i, image in enumerate(frames):
        canvas.paste(image, ((i % 2) * w, (i // 2) * h))
    canvas.save(out)
    print(f"{video}: {duration:.1f}s, {len(frames)} frames -> {out}")


if __name__ == "__main__":
    fractions = [float(f) for f in sys.argv[3].split(",")] if len(sys.argv) > 3 else [0.2, 0.5, 0.8, 0.99]
    sheet(sys.argv[1], sys.argv[2], fractions)
