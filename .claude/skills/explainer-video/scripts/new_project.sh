#!/usr/bin/env bash
# Create a new explainer project from the bundled template and install its environment.
#   new_project.sh <project-dir>
set -euo pipefail
[[ $# -eq 1 ]] || { echo "usage: $0 <project-dir>" >&2; exit 2; }
dest=$1
[[ ! -e "$dest" ]] || { echo "$dest already exists" >&2; exit 1; }
template="$(cd "$(dirname "$0")/../assets/template" && pwd)"
cp -R "$template" "$dest"
cd "$dest"
name=$(basename "$PWD" | tr -c 'a-zA-Z0-9-\n' '-')
sed -i.bak "s/^name = \"explainer-video\"/name = \"$name\"/" pyproject.toml && rm pyproject.toml.bak
git init -q
uv sync --python 3.12 -q
echo "Created $PWD. Next: uv run manim -pql scenes.py S01Overview"
