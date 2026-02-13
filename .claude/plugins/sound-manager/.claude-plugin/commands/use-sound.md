---
name: use-sound
description: Switch notification sound theme (pokemon or aoe)
args:
  - name: theme
    description: Sound theme to use (pokemon or aoe)
    required: true
---

# Use Sound Theme

This command switches the notification sound theme for the current session.

Available themes:
- **aoe**: Plays Age of Empires 2 villager sounds (varies by session) — default
- **pokemon**: Plays Charizard cry on notifications

## Implementation

```bash
#!/bin/bash
THEME="${theme}"
STATE_DIR="$HOME/.claude/state/notify"
SOUND_PREF_FILE="$STATE_DIR/sound-theme.json"

# Validate theme
if [[ "$THEME" != "pokemon" && "$THEME" != "aoe" ]]; then
  echo "Invalid theme. Use 'pokemon' or 'aoe'"
  exit 1
fi

# Create state directory if needed
mkdir -p "$STATE_DIR"

# Save preference
echo "{\"theme\": \"$THEME\"}" > "$SOUND_PREF_FILE"

echo "Notification sounds set to: $THEME"
```
