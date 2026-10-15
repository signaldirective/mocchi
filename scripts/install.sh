#!/bin/bash
# install.sh — wire Mocchi's skill into the agent harnesses.
#
# Run this once after adding the plugin. It does two things, both idempotent:
#
#   1. Links the bundled skill into ~/.agents/skills/mocchi, the shared skills
#      directory OpenCode (and other agents) discover. This mirrors how Omarchy
#      installs its own `omarchy` and `diagnose-crash` skills, so the link
#      tracks the plugin: `omarchy plugin update` refreshes the content.
#
#   2. Registers the skill's always-on digest in OpenCode's `instructions`, so
#      the core rules are present in every session — not only when the model
#      loads the skill on demand.
#
# It edits ~/.config/opencode/opencode.json in place (leaving a backup first)
# and never touches anything else.

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
SKILL_DIR="$REPO_DIR/skills/mocchi"
LINK="$HOME/.agents/skills/mocchi"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

if [[ ! -f "$SKILL_DIR/SKILL.md" || ! -f "$SKILL_DIR/instructions.md" ]]; then
  echo "install.sh: bundled skill not found under $SKILL_DIR" >&2
  exit 1
fi

# Belt and braces: a plain copy (or a git checkout that lost the mode) can drop
# the executable bit the bar widget and the greeting click action rely on.
chmod +x "$REPO_DIR/scripts/mocchi-ask" "$REPO_DIR/scripts/mocchi-greet" 2>/dev/null || true

if ! command -v jq >/dev/null 2>&1; then
  echo "install.sh: jq is required to update the OpenCode config." >&2
  exit 1
fi

# 1. Link the skill where agents look for it.
mkdir -p "$(dirname "$LINK")"
if [[ -L $LINK ]]; then
  current=$(readlink -f "$LINK" || true)
  if [[ $current != "$SKILL_DIR" ]]; then
    echo "install.sh: $LINK already points to $current; leaving it as-is." >&2
  fi
elif [[ -e $LINK ]]; then
  echo "install.sh: $LINK exists and is not a symlink; leaving it as-is." >&2
else
  ln -s "$SKILL_DIR" "$LINK"
  echo "Linked skill:      $LINK -> $SKILL_DIR"
fi

if [[ ! -f "$LINK/instructions.md" ]]; then
  echo "install.sh: $LINK/instructions.md is missing; not changing the OpenCode config." >&2
  exit 1
fi

# 2. Register the always-on instructions.
CONFIG_FILE="$CONFIG_DIR/opencode.json"
if [[ ! -f $CONFIG_FILE && -f "$CONFIG_DIR/opencode.jsonc" ]]; then
  CONFIG_FILE="$CONFIG_DIR/opencode.jsonc"
fi

mkdir -p "$CONFIG_DIR"
[[ -f $CONFIG_FILE ]] || printf '{}\n' >"$CONFIG_FILE"
cp -n "$CONFIG_FILE" "$CONFIG_FILE.mocchi.bak" 2>/dev/null || true

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
jq --arg instructions "$LINK/instructions.md" '
  .instructions = (((.instructions // []) + [$instructions]) | unique)
' "$CONFIG_FILE" >"$tmp"
# Write in place so the file's permissions are kept and a symlinked config
# (common with dotfile managers) is followed rather than replaced.
cat "$tmp" >"$CONFIG_FILE"

echo "Instructions:      $LINK/instructions.md"
echo "Updated:           $CONFIG_FILE"

# 3. Point the user at enabling the icon.
if command -v omarchy >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  echo "Enable the icon:   omarchy plugin enable io.github.signaldirective.mocchi --section right"
fi
