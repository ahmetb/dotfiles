# Scene patterns

Layouts that worked in a real 8-minute system explainer. Each snippet sits inside a
`beat_<n>(self, tracker, _)` method with `d = tracker.duration`. Imports come from
`manim` and `explainer.style`. The frame is 14.2 × 8 units with the origin at the centre;
the title occupies the top 1.2 units.

Contents
1. Pipeline with travelling packets
2. Registration / discovery reveal
3. Checklist with a side panel
4. Code stack and a fork
5. Timeline lanes (concurrency, pauses, gates)
6. Side channel (tap before, attach after)
7. Interval grid with a brace
8. Checks row and before/after replacement
9. Layout pitfalls

## 1. Pipeline with travelling packets

Components in one row, arrows between nearest edges, and data riding the arrows. Leave at
least 0.7 units between boxes, or packets cover the box labels.

```python
self.client = Component("Client", INK, "HTTP request", width=2.2).move_to(LEFT * 5.8 + UP * 0.7)
self.frontend = Component("Frontend", FRONTEND, "template + tokenize", width=2.8).move_to(LEFT * 2.5 + UP * 0.7)
self.a_cf = link(self.client, self.frontend)
self.play(FadeIn(self.client), FadeIn(self.frontend), GrowArrow(self.a_cf), run_time=d * 0.25)
request = Packet("POST /v1/chat", INK)
self.play(ride(request, forward(self.a_cf), run_time=d * 0.25))
self.play(ReplacementTransform(request, Packet("[151, 9, 42, …]", FRONTEND).next_to(self.frontend, UP)),
          run_time=d * 0.25)   # Packet→Packet morphs are fine; Text→Text morphs garble
```

Return streams: send several packets back with `LaggedStart(*(ride(c, back(a2), back(a1), run_time=d*0.45) for c in chunks), lag_ratio=0.25)`.
On a short arrow, route packets along a lane below the boxes instead of over them:
`ride(c, (worker.get_bottom() + DOWN * 0.45, frontend.get_bottom() + DOWN * 0.45))`.

## 2. Registration / discovery reveal

Show a new component dimmed, send a "card" to a registry, then light it up and grow the
arrow that makes it reachable. End on a one-line takeaway in `DANGER` or `WORKER`.

```python
late = Component("Worker C", WORKER, "just started", width=2.8).move_to(RIGHT * 5.3 + DOWN * 2.8).set_opacity(0.3)
a_wd = link(late, discovery, color=DISCOVERY)
self.play(ride(Packet("model card", DISCOVERY), forward(a_wd), run_time=d * 0.2))
self.play(late.animate.set_opacity(1), GrowArrow(link(router, late)), run_time=d * 0.15)
self.play(Write(label("registered  =  routable", size=30, color=DANGER, weight="BOLD")), run_time=d * 0.2)
```

## 3. Checklist with a side panel

Ordered steps on the left. Per beat: highlight the current step, turn earlier ones green,
and swap the right-hand panel. Scale any panel wider than 7.6 units, and keep its centre
near `RIGHT * 2.7`, so it never touches the list.

```python
self.steps = VGroup(*(label(t, size=24, color=MUTED) for t in STEPS)).arrange(DOWN, aligned_edge=LEFT, buff=0.42)
self.steps.to_edge(LEFT, buff=0.6)
self.cursor = None

PANEL = RIGHT * 2.7 + DOWN * 0.3

def light(self, i, run_time):
    box = SurroundingRectangle(self.steps[i], color=RL, buff=0.12, corner_radius=0.08)
    anims = [self.steps[i].animate.set_color(INK), FadeIn(box)]
    anims += [self.steps[k].animate.set_color(WORKER) for k in range(i)]
    if self.cursor is not None:
        anims.append(FadeOut(self.cursor))
    self.cursor = box
    self.play(*anims, run_time=run_time)

def show_panel(self, group, run_time):
    if getattr(self, "panel", None) is not None:
        self.play(FadeOut(self.panel), run_time=run_time * 0.4)
    if group.width > 7.6:
        group.scale_to_fit_width(7.6)
    self.play(FadeIn(group.move_to(PANEL), shift=UP * 0.15), run_time=run_time * 0.6)
    self.panel = group
```

Put tags on child boxes *below* the box when arrows arrive from above; tags on top collide
with arrow tips.

## 4. Code stack and a fork

Function names as outlined monospace boxes (`SurroundingRectangle` around `label(..., mono=True)`),
stacked to show the call chain. For "two paths, same native call", put one box on the left
and one on the right, arrows down to a shared box, and put the path labels to the side of
the arrows. Labels where arrows end get covered by the tips.

```python
def code_box(text, color):
    body = label(text, size=20, mono=True, color=color)
    frame = SurroundingRectangle(body, color=color, buff=0.18, corner_radius=0.1).set_fill(color, opacity=0.1)
    return VGroup(frame, body)
```

Put the extras one path adds (e.g. "admission gate") in a small chip column beside the
shared box, not next to a box at the frame edge, where it will fall off-screen.

## 5. Timeline lanes

Best for anything temporal: pauses, gates, retries, version changes during a request.
Map time 0–10 onto x, give each actor a lane at a fixed y, then draw solid `Line` bars for
activity, `DashedLine` for waiting or paused, and a translucent `Rectangle` over the lanes
it blocks.

```python
LEFT_X, RIGHT_X = -3.6, 6.4
LANES = {"policy": 2.15, "update": 1.25, "A": 0.25, "B": -0.75, "health": -1.85}
x = lambda t: LEFT_X + (RIGHT_X - LEFT_X) * t / 10
at = lambda t, lane: [x(t), LANES[lane], 0]
bar = lambda t0, t1, lane, color, dashed=False: (DashedLine if dashed else Line)(
    at(t0, lane), at(t1, lane), color=color, stroke_width=6 if dashed else 10)
self.play(Create(bar(0.4, 3.0, "A", FRONTEND), rate_func=linear), run_time=d * 0.35)
```

Lane names go at `x = -5.2`. Put event chips (`chip("pause in place", RL)`) on the
update lane and keep them at least 1.8 time units apart. Put gate captions inside the
gate's lower edge, not on a lane that has its own caption. Heartbeats work well as rows
of `Dot`s that change colour during the pause.

## 6. Side channel (tap before, attach after)

For data that bypasses a lossy stage (parsers, a cache, compression): show the lossy path
first (cross out what is lost), then add a tap arrow from the source to a "relay" box
under the stage, a list of what it holds as `chip`s, and finally the per-output-chunk rows
that it attaches. End with the reconstructed result equal to the source.

## 7. Interval grid with a brace

Token, record or offset ranges: a row of `Square` cells (prompt cells in one colour,
output cells in another), a `BraceBetweenPoints` under the covered cells with the
interval formula as a label, and the excluded cell dimmed with a short reason above it.
`Brace.get_text` needs LaTeX; use `label(...).next_to(brace, DOWN)` instead.

## 8. Checks row and before/after replacement

Validation rules as a row of chips near the bottom (`move_to(DOWN * 1.5)`), the failure
rule in `DANGER`. For "X replaces Y", show Y, `Create(Cross(Y))`, then
`FadeOut(Y)` and `FadeIn(X, shift=UP * 0.1)`.

## 9. Layout pitfalls

- `Component` grows to fit its text, but neighbours don't move: recheck spacing after
  renaming. Keep detail lines under about 26 characters.
- Keep everything within x ∈ [-6.8, 6.8] and y ∈ [-3.7, 2.9].
- `next_to(obj, RIGHT)` on an object near the right edge goes off-frame. Position from
  the centre instead.
- Bottom captions: `to_edge(DOWN, buff=0.6)`. Check they don't collide with the lowest boxes.
- Long monospace lines at size 20 are about 0.12 units per character; 50 characters ≈ 6 units.
- Fade out the previous beat's leftovers explicitly, or call `self.clear()`; stale labels
  are the most common frame-sheet defect.
