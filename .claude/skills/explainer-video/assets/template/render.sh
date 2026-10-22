#!/usr/bin/env bash
# Render every scene in order and join them into explainer.mp4.
#   ./render.sh          draft: 480p15
#   ./render.sh final    1080p30 (add VOICE=record for your own voice)
set -euo pipefail
cd "$(dirname "$0")"
quality=(-ql) folder=480p15
if [[ "${1:-}" == final ]]; then quality=(-qh --frame_rate 30) folder=1080p30; fi
scenes=$(uv run python -c 'from explainer.narration import ORDER; print(" ".join(ORDER))' 2>/dev/null)
uv run manim "${quality[@]}" scenes.py $scenes
files=()
for scene in $scenes; do files+=("media/videos/scenes/$folder/$scene.mp4"); done
uv run python -m explainer.join explainer.mp4 "${files[@]}" 2>/dev/null
