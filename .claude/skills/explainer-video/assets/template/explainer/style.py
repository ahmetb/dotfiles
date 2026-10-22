"""Shared visual language: one colour per role, boxes, arrows and token packets."""

from manim import (
    DOWN,
    RIGHT,
    UP,
    Arrow,
    Line,
    MoveAlongPath,
    RoundedRectangle,
    Succession,
    Text,
    VGroup,
    config,
    linear,
)

config.background_color = "#0f1117"

FONT = "Avenir Next"
MONO = "Menlo"

INK = "#e6e8ee"
MUTED = "#8a90a2"
FRONTEND = "#5b9cff"
ROUTER = "#b483ff"
WORKER = "#3ccf91"
ENGINE = "#2a9d6f"
RL = "#ffb347"
DISCOVERY = "#f06c9b"
DANGER = "#ff5c5c"


def label(text, size=28, color=INK, mono=False, weight="NORMAL"):
    return Text(text, font=MONO if mono else FONT, font_size=size, color=color, weight=weight)


def title(text):
    return label(text, size=44, weight="BOLD").to_edge(UP, buff=0.45)


class Component(VGroup):
    """A titled process box. ``detail`` is an optional second line."""

    def __init__(self, name, color, detail=None, width=3.2, height=1.3):
        heading = label(name, size=30, color=color, weight="BOLD")
        parts = [heading]
        if detail is not None:
            parts.append(label(detail, size=20, color=MUTED))
        text = VGroup(*parts).arrange(DOWN, buff=0.12)
        box = RoundedRectangle(
            corner_radius=0.18,
            width=max(width, text.width + 0.5),
            height=max(height, text.height + 0.4),
            stroke_color=color,
            stroke_width=3,
            fill_color=color,
            fill_opacity=0.12,
        )
        text.move_to(box)
        super().__init__(box, text)
        self.box = box
        self.color = color


def link(start, end, color=MUTED, buff=0.12):
    """Arrow between two components' nearest edges."""
    direction = end.get_center() - start.get_center()
    if abs(direction[0]) >= abs(direction[1]):
        a, b = (start.get_right(), end.get_left()) if direction[0] > 0 else (start.get_left(), end.get_right())
    else:
        a, b = (start.get_top(), end.get_bottom()) if direction[1] > 0 else (start.get_bottom(), end.get_top())
    return Arrow(a, b, buff=buff, color=color, stroke_width=4, max_tip_length_to_length_ratio=0.12)


class Packet(VGroup):
    """A small labelled message that travels along arrows."""

    def __init__(self, text, color=INK):
        body = label(text, size=18, color="#0f1117", mono=True, weight="BOLD")
        pill = RoundedRectangle(
            corner_radius=0.12,
            width=body.width + 0.3,
            height=body.height + 0.22,
            stroke_width=0,
            fill_color=color,
            fill_opacity=1,
        )
        body.move_to(pill)
        super().__init__(pill, body)


def ride(packet, *segments, run_time=1.5):
    """Move ``packet`` along straight segments given as (start, end) point pairs."""
    lines = [Line(a, b) for a, b in segments]
    packet.move_to(lines[0].get_start())
    return Succession(
        *(MoveAlongPath(packet, line, rate_func=linear, run_time=run_time / len(lines)) for line in lines)
    )


def forward(arrow):
    return arrow.get_start(), arrow.get_end()


def back(arrow):
    return arrow.get_end(), arrow.get_start()


def tokens(values, color=INK):
    """A row of token chips, e.g. ``tokens(["10", "11", "<stop>"])``."""
    return VGroup(*(Packet(value, color) for value in values)).arrange(RIGHT, buff=0.1)


def ride_path(packet, path, run_time=1.5):
    """Move ``packet`` along any path mobject, such as a curved arrow."""
    packet.move_to(path.get_start())
    return MoveAlongPath(packet, path, rate_func=linear, run_time=run_time)


def chip(text, color, size=20):
    """An outlined tag, for states and checks rather than moving data."""
    body = label(text, size=size, color=color)
    frame = RoundedRectangle(
        corner_radius=0.1,
        width=body.width + 0.3,
        height=body.height + 0.2,
        stroke_color=color,
        stroke_width=2,
        fill_color=color,
        fill_opacity=0.1,
    )
    body.move_to(frame)
    return VGroup(frame, body)
