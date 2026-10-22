"""Join rendered scene files into one MP4 without re-encoding (PyAV ships with Manim)."""

import sys
from fractions import Fraction

import av


def join(inputs, output):
    sources = [av.open(path) for path in inputs]
    out = av.open(output, "w")
    template = sources[0]
    streams = {kind: out.add_stream_from_template(getattr(template.streams, kind)[0]) for kind in ("video", "audio")}
    elapsed = Fraction(0)
    for source in sources:
        inputs_ = {kind: getattr(source.streams, kind)[0] for kind in streams}
        shifts = {kind: int(elapsed / stream.time_base) for kind, stream in inputs_.items()}
        # Demux both streams in one pass; a second pass over the file would yield nothing.
        for packet in source.demux(*inputs_.values()):
            if packet.dts is None:
                continue
            kind = packet.stream.type
            packet.pts += shifts[kind]
            packet.dts += shifts[kind]
            packet.stream = streams[kind]
            out.mux(packet)
        elapsed += Fraction(source.duration, av.time_base)
        source.close()
    out.close()
    return float(elapsed)


if __name__ == "__main__":
    seconds = join(sys.argv[2:], sys.argv[1])
    print(f"Wrote {sys.argv[1]} ({seconds / 60:.1f} min)")
