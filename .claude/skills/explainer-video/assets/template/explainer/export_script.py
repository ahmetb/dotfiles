"""Write script.md from narration.py and report the estimated running time."""

from pathlib import Path

from explainer.narration import ORDER, SCENES

WORDS_PER_MINUTE = 145


def main():
    lines, total = ["# Narration script", ""], 0
    for key in ORDER:
        heading, beats = SCENES[key]
        words = sum(len(beat.split()) for beat in beats)
        total += words
        lines += [f"## {heading} (`{key}`, {words} words, ~{words / WORDS_PER_MINUTE:.1f} min)", ""]
        lines += [beat + "\n" for beat in beats]
    lines.insert(2, f"{total} words, about {total / WORDS_PER_MINUTE:.1f} minutes at {WORDS_PER_MINUTE} wpm.\n")
    Path("script.md").write_text("\n".join(lines))
    print(f"script.md: {total} words, ~{total / WORDS_PER_MINUTE:.1f} min")


if __name__ == "__main__":
    main()
