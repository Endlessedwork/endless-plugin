#!/bin/bash
set -e

REPO_URL="https://github.com/Endlessedwork/endless-plugin.git"
PLUGIN_NAME="endless"
COMMANDS_DIR="$HOME/.claude/commands/endless"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing endless plugin..."

# 1. Register marketplace + install plugin
claude plugin marketplace add "$REPO_URL" 2>/dev/null || true
claude plugin install "$PLUGIN_NAME" 2>/dev/null || true

# 2. Copy commands to ~/.claude/commands/endless/ for autocomplete
mkdir -p "$COMMANDS_DIR"
cp "$SCRIPT_DIR/commands/ooda.md"     "$COMMANDS_DIR/ooda.md"
cp "$SCRIPT_DIR/commands/scaffold.md" "$COMMANDS_DIR/scaffold.md"
cp "$SCRIPT_DIR/commands/flow.md"     "$COMMANDS_DIR/flow.md"

echo "Done! Reload plugins with /reload-plugins then use:"
echo "  /endless:ooda"
echo "  /endless:scaffold"
echo "  /endless:flow"
