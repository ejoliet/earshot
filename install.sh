#!/usr/bin/env bash
# Installs earshot to ~/.local/bin (override with EARSHOT_BIN) and installs uv if missing.
set -euo pipefail
BIN="${EARSHOT_BIN:-$HOME/.local/bin}"
RAW="https://raw.githubusercontent.com/ejoliet/earshot/main"
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
mkdir -p "$BIN"
curl -fsSL "$RAW/earshot.py" -o "$BIN/earshot"
chmod +x "$BIN/earshot"
# Pre-download Python deps so UV_OFFLINE=1 earshot works later.
uv sync --quiet --script "$BIN/earshot"
if [[ $(uname -s) == Linux ]] && ! ldconfig -p 2>/dev/null | grep -q libportaudio; then
  echo "PortAudio missing. Debian/Ubuntu: sudo apt-get install libportaudio2"
fi
echo "Installed $BIN/earshot"
case ":$PATH:" in *":$BIN:"*) ;; *) echo "Add to your shell profile: export PATH=\"$BIN:\$PATH\"" ;; esac
