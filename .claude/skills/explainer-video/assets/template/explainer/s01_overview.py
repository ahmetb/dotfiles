"""Example scene: components, arrows, a travelling packet, chips and a cleared stage."""

from manim import DOWN, LEFT, RIGHT, UP, Create, Cross, FadeIn, GrowArrow, VGroup

from explainer.base import NarratedScene
from explainer.style import (
    DANGER,
    ENGINE,
    FRONTEND,
    INK,
    WORKER,
    Component,
    Packet,
    back,
    chip,
    forward,
    label,
    link,
    ride,
)


class S01Overview(NarratedScene):
    def beat_1(self, tracker, _):
        d = tracker.duration
        self.client = Component("Client", INK, "HTTP request", width=2.4).move_to(LEFT * 4.8 + UP * 0.6)
        self.gateway = Component("Gateway", FRONTEND, "validates", width=2.6).move_to(UP * 0.6)
        self.a_cg = link(self.client, self.gateway)
        self.play(FadeIn(self.client), FadeIn(self.gateway), GrowArrow(self.a_cg), run_time=d * 0.3)
        request = Packet("request", INK)
        self.play(ride(request, forward(self.a_cg), run_time=d * 0.3))
        checks = chip("schema ok", WORKER).next_to(self.gateway, DOWN, buff=0.3)
        self.play(FadeIn(checks), request.animate.set_opacity(0), run_time=d * 0.2)

    def beat_2(self, tracker, _):
        d = tracker.duration
        self.worker = Component("Worker", WORKER, "does the work", width=2.6).move_to(RIGHT * 4.8 + UP * 0.6)
        self.a_gw = link(self.gateway, self.worker)
        self.play(FadeIn(self.worker), GrowArrow(self.a_gw), run_time=d * 0.25)
        chunks = [Packet(f"chunk {i}", ENGINE) for i in (1, 2)]
        for chunk in chunks:
            self.play(ride(chunk, back(self.a_gw), back(self.a_cg), run_time=d * 0.3))
        self.remove(*chunks)

    def beat_3(self, tracker, _):
        d = tracker.duration
        fail = Cross(self.worker, stroke_color=DANGER, stroke_width=5)
        self.play(Create(fail), run_time=d * 0.25)
        error = VGroup(label("error, never a partial answer", size=24, color=DANGER))
        error.next_to(self.client, DOWN, buff=0.6)
        self.play(FadeIn(error), run_time=d * 0.25)
        self.wait(d * 0.2)
        self.clear(run_time=d * 0.15)
