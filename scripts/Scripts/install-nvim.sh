#!/usr/bin/env bash
# Install a pinned stable Neovim release into ~/.local (no sudo).
# To update: change VERSION and SHA256 (from the GitHub release page), rerun.
set -euo pipefail

VERSION="v0.12.6"
SHA256="474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87"
URL="https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-x86_64.tar.gz"

DEST="$HOME/.local/opt/nvim-${VERSION#v}"
BIN="$HOME/.local/bin/nvim"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fL --progress-bar -o "$tmp/nvim.tar.gz" "$URL"
echo "${SHA256}  $tmp/nvim.tar.gz" | sha256sum -c -

mkdir -p "$DEST" "$(dirname "$BIN")"
tar -xzf "$tmp/nvim.tar.gz" -C "$DEST" --strip-components=1
ln -sfn "$DEST/bin/nvim" "$BIN"

"$BIN" --version | head -1
