"""All scenes, in running order. Render one with:

    uv run manim -pql scenes.py S01Overview

Each scene is implemented in its own module under explainer/. Manim only renders scenes
defined in the file it is given, so each is re-declared here. A beat without a
``beat_<n>`` method shows its narration as a caption.
"""

from explainer import s01_overview
from explainer.base import NarratedScene


class S01Overview(s01_overview.S01Overview):
    pass


class S02Next(NarratedScene):
    pass
