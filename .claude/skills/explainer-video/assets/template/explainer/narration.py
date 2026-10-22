"""The narration, one list of beats per scene. This is the single source of the script.

Each beat is spoken in one voiceover block; a scene's animations for that beat are sized
to the beat's audio. Edit here, then run `uv run python -m explainer.export_script`.
Replace these example scenes with your own; keys must match the class names in scenes.py.
"""

SCENES = {
    "S01Overview": (
        "How a request flows",
        [
            "A client sends a request to the service. The gateway checks it and passes it on.",
            "The worker does the real work and streams the result back the way it came.",
            "If the worker fails, the gateway returns an error instead of a partial answer.",
        ],
    ),
    "S02Next": (
        "What comes next",
        [
            "This scene has no animation yet, so its narration is shown as a caption.",
        ],
    ),
}

ORDER = list(SCENES)
