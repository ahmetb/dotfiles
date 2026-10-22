"""Base scene: loads a scene's narration beats and plays one voiceover block per beat."""

from manim import FadeIn, FadeOut, Write
from manim_voiceover import VoiceoverScene

from explainer.narration import SCENES
from explainer.style import MUTED, label, title
from explainer.voice import speech_service


class NarratedScene(VoiceoverScene):
    """Loads this scene's beats from narration.py; subclasses implement ``beat_<n>``."""

    def setup(self):
        super().setup()
        self.set_speech_service(speech_service())
        self.heading, self.beats = SCENES[type(self).__name__]

    def construct(self):
        self.title_mob = title(self.heading)
        self.play(Write(self.title_mob), run_time=0.6)
        for index, text in enumerate(self.beats, start=1):
            with self.voiceover(text=text) as tracker:
                getattr(self, f"beat_{index}", self.placeholder)(tracker, text)
        self.wait(0.3)

    def placeholder(self, tracker, text):
        caption = label(_wrap(text), size=24, color=MUTED)
        self.play(FadeIn(caption), run_time=0.4)
        self.wait(max(tracker.duration - 0.8, 0.01))
        self.play(FadeOut(caption), run_time=0.4)

    def clear(self, run_time=0.5):
        """Fade out everything except the scene title."""
        others = [m for m in self.mobjects if m is not self.title_mob]
        if others:
            self.play(*(FadeOut(m) for m in others), run_time=run_time)


def _wrap(text, width=70):
    lines, line = [], ""
    for word in text.split():
        if len(line) + len(word) >= width:
            lines.append(line)
            line = ""
        line += word + " "
    return "\n".join(lines + [line])
