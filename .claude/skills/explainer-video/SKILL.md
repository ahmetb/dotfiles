---
name: explainer-video
description: Make a narrated, animated explainer video (MP4, about 5–10 minutes) for any concept, system, architecture, PR or code path, built with Manim Community Edition and narrated by the local Kokoro-82M `af_heart` voice. Includes a project template (narration-driven scenes, shared visual style, offline voice with pronunciation fixes, MP4 joiner) and QA scripts (frame contact sheets, audio checks, pronunciation checks). Use when asked to make, script, storyboard, render, narrate or fix an explainer or walkthrough video, an animated system diagram with voiceover, or a 3Blue1Brown-style technical video.
---

# Explainer video

Produce a narrated MP4 where every visual beat is timed to its spoken line. Accuracy comes first: the video teaches, so every claim must be checked against the source.

## Tools

- **Manim Community Edition** (Python, MIT) renders scenes deterministically. Use `Text`, never `Tex`/`MathTex` (no LaTeX installed).
- **manim-voiceover** plays one voiceover block per beat; animations are sized to that block's audio.
- **Kokoro-82M, voice `af_heart`** narrates locally: free, no API key, and the script never leaves the machine. The template synthesises sentence by sentence with short pauses and adds a gap after each beat. Without those pauses viewers hear the narration as choppy.
- **PyAV** (bundled with Manim) joins scene files without ffmpeg.

Do not switch to a hosted voice (ElevenLabs, Gemini, OpenAI) unless the user asks: it sends the script to a third party. `VOICE=say` (macOS) is for instant timing drafts only. `VOICE=record` records the user's own voice.

Requires macOS or Linux, `uv`, and Python 3.11–3.12 (Kokoro does not support 3.13). The first Kokoro run downloads about 330 MB from Hugging Face.

## Workflow

### 1. Understand and verify the subject

Read the real source first: code, PR diff, design docs, logs. Delegate wide reading to subagents. Write down the mechanism as a flow of information between named components, then list the claims the video will make. Each claim must trace to a file, line or document. Mark anything inferred and either verify it or leave it out. Diagrams labelled "illustrative" must say so on screen.

### 2. Write the narration

Edit `explainer/narration.py`: an ordered dict of scenes, each a `(heading, [beats])` pair.

- One beat is 1–3 sentences (about 20–50 words) and covers one visual change.
- Use 6–10 scenes for 5–10 minutes. Budget about 150 words per minute (`uv run python -m explainer.export_script` reports the estimate and writes `script.md` for review).
- Arc: why it matters → the cast of components → the main flow → the tricky case (failure, concurrency, update) → the fix or design choice → scope and limits.
- Write for the ear: short sentences, no parentheses, expand abbreviations on first use, no symbols the voice must read aloud.

Show the script to the user before building scenes when the subject is theirs: it is cheaper to fix words than animations.

### 3. Scaffold the project

```bash
bash <skill-dir>/scripts/new_project.sh <project-dir>   # copies assets/template, runs uv sync
cd <project-dir> && uv run manim -pql scenes.py S01Overview
```

Template layout:

| Path | Role |
|---|---|
| `explainer/narration.py` | The script. Single source of truth. |
| `explainer/style.py` | Colours per role and helpers: `Component`, `link`, `Packet`, `ride`, `ride_path`, `chip`, `tokens`, `label`, `title` |
| `explainer/base.py` | `NarratedScene`: plays each beat, calls `beat_<n>(tracker, text)`, falls back to a caption; `self.clear()` empties the stage |
| `explainer/voice.py` | Voice selection, `PRONUNCIATIONS` respellings, sentence pauses |
| `explainer/sNN_*.py` | One module per scene |
| `scenes.py` | Entry point. Re-declare every scene here (Manim only renders classes defined in the file it is given). |
| `render.sh` | `./render.sh` draft (480p15) or `./render.sh final` (1080p30); joins into `explainer.mp4` |

Rename the colour roles in `style.py` to the subject's actors. Replace the example scenes. Scenes with no `beat_<n>` methods render as captions, so the whole video plays end to end from the first day.

### 4. Fix pronunciation

```bash
uv run python <skill-dir>/scripts/pronounce.py "etcd" "SGLang" "KV cache"
```

Check every product name, acronym and code word in the script. Add respellings to `PRONUNCIATIONS` in `voice.py` (e.g. `"etcd": "et see dee"`, `"sglang-rl": "S G Lang R L"`). They change only the audio; on-screen text and subtitles keep the original spelling. Ask the user how their team says ambiguous names (is BIS "biss" or "B-I-S"?).

### 5. Build scenes one at a time

For each beat, size every `self.play(..., run_time=d * f)` as a fraction of `d = tracker.duration`, keeping the fractions under about 0.9 of the beat. The voiceover block waits out the remainder, so changing words or voice never desynchronises a scene. Store mobjects on `self` to reuse them in later beats; call `self.clear()` before a new layout.

Read [references/scene-patterns.md](references/scene-patterns.md) for layouts that worked: pipeline with travelling packets, checklist with a side panel, code stack and fork, timeline lanes, side channel, interval grid, and a checks row. It also lists the layout pitfalls.

### 6. Check visually after every scene

```bash
uv run manim -ql scenes.py S03Startup
uv run python <skill-dir>/scripts/frame_sheet.py media/videos/scenes/480p15/S03Startup.mp4 /tmp/sheet.png 0.15,0.35,0.55,0.75,0.9,0.99
```

Read the PNG. Pick fractions near the end of each beat. Look for: text overflowing boxes, labels under arrow tips, overlaps, elements off-frame, half-finished transforms, empty frames. Fix and re-render. Never report a scene as done without having looked at its frames.

### 7. Render the final video and check the audio

```bash
./render.sh final                                         # run in the background; several minutes
uv run python <skill-dir>/scripts/audio_check.py explainer.mp4
```

Expect discontinuities only at scene joins and no clipping. Audio is cached in `media/voiceovers/` by text, voice and pause settings, so later renders only synthesise changed beats. Then `open explainer.mp4` (macOS) and give the user the path, duration, and anything not verified.

## Gotchas

- espeak-ng (Kokoro's fallback for unknown words) fails when the virtualenv path is longer than about 160 characters: `Error processing file '.../site-packages/phontab'`. `voice.py` copies its data to `/tmp` to avoid this. A symlink does not work.
- Kokoro needs `transformers>=4.45` and the spaCy `en_core_web_sm` wheel; both are pinned in the template's `pyproject.toml`. Without the pin, uv resolves an ancient `transformers` that fails to build.
- The `SoX could not be found` warning is harmless (SoX is only used for `global_speed`).
- Pango strips leading spaces in `Text`; indent code lines by shifting them.
- `ReplacementTransform` between two different `Text` objects garbles mid-morph; fade one out and the other in.
- When remuxing MP4s with PyAV, demux audio and video in one pass (`join.py` does); a second pass over a file yields no packets and silently drops the audio.
- Bitstream differences of about 1e-4 between joined and source audio are decoder rounding, not a defect.
