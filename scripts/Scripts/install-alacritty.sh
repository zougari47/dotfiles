#!/usr/bin/env bash
# Build a pinned Alacritty release from source into ~/.local (no sudo for the build).
#
# Safety: the release tag must carry a valid GPG signature from the maintainer's
# pinned key, and must point at the pinned commit. Rust dependencies are locked
# by checksum in the repo's Cargo.lock (--locked).
# To update: change VERSION and COMMIT (from the release's tag on GitHub), rerun;
# the signature check tells you if the new tag is genuine.
set -euo pipefail

VERSION="0.17.0"
COMMIT="94e7c8874e526b1e67b349d9ba30ddf81669119e"
REPO="https://github.com/alacritty/alacritty.git"

# Christian Dürr, Alacritty maintainer; signs the release tags.
KEY_FPR="4DAA67A9EA8B91FCC15B699C85CDAE3C164BA7B4"
KEY_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/${KEY_FPR}"

# Build dependencies, all from the Ubuntu archive (list from Alacritty's INSTALL.md).
DEPS=(cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
      python3 git curl gpg ncurses-bin)

DEST="$HOME/.local/opt/alacritty-${VERSION}"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"
COMPLETION_DIR="$HOME/.local/share/bash-completion/completions"

if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal user, not root (sudo is asked for only for apt)." >&2
    exit 1
fi

command -v cargo >/dev/null || { echo "cargo not found; install Rust with rustup first." >&2; exit 1; }

missing=()
for pkg in "${DEPS[@]}"; do
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed" \
        || missing+=("$pkg")
done
if ((${#missing[@]})); then
    echo "Missing build dependencies: ${missing[*]}"
    read -rp "Install them with 'sudo apt-get install --no-install-recommends'? [y/N] " ans
    [[ $ans == [yY] ]] || { echo "Aborted." >&2; exit 1; }
    sudo apt-get install -y --no-install-recommends "${missing[@]}"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -m 700 "$tmp/gnupg"
export GNUPGHOME="$tmp/gnupg"   # throwaway keyring: your own ~/.gnupg is never touched

curl -fsSL --proto '=https' --tlsv1.2 -o "$tmp/key.asc" "$KEY_URL"
gpg --batch --quiet --import "$tmp/key.asc"

git -c advice.detachedHead=false clone --quiet --depth 1 --branch "v${VERSION}" "$REPO" "$tmp/src"

# The signature must be good AND made by the pinned key, not just any key.
status="$(git -C "$tmp/src" verify-tag --raw "v${VERSION}" 2>&1)" || true
if ! grep -q "^\[GNUPG:\] GOODSIG " <<<"$status" \
    || ! grep -q "^\[GNUPG:\] VALIDSIG .* ${KEY_FPR}$" <<<"$status"; then
    echo "Tag v${VERSION} is not signed by ${KEY_FPR}:" >&2
    echo "$status" >&2
    exit 1
fi
head="$(git -C "$tmp/src" rev-parse HEAD)"
if [[ $head != "$COMMIT" ]]; then
    echo "Tag v${VERSION} points at $head, expected $COMMIT" >&2
    exit 1
fi
echo "Tag v${VERSION} verified: signed by ${KEY_FPR}, commit ${COMMIT}"

CARGO_TARGET_DIR="$tmp/target" cargo build --release --locked --manifest-path "$tmp/src/Cargo.toml"

# Install to a staging dir, then swap it in, so a failed install never leaves
# a half-written $DEST behind.
staging="${DEST}.new"
rm -rf "$staging"
mkdir -p "$staging/bin" "$staging/share"
install -s -m 755 "$tmp/target/release/alacritty" "$staging/bin/alacritty"
install -m 644 "$tmp/src/extra/linux/Alacritty.desktop" "$staging/share/Alacritty.desktop"
install -m 644 "$tmp/src/extra/logo/alacritty-term.svg" "$staging/share/Alacritty.svg"
install -m 644 "$tmp/src/extra/completions/alacritty.bash" "$staging/share/alacritty.bash"
rm -rf "$DEST"
mv "$staging" "$DEST"

mkdir -p "$BIN_DIR" "$APP_DIR" "$ICON_DIR" "$COMPLETION_DIR"
ln -sfn "$DEST/bin/alacritty" "$BIN_DIR/alacritty"
# Copied, not symlinked: KDE refuses to launch a .desktop file whose real path
# is outside the applications dirs ("not authorized to execute this file").
install -m 644 "$DEST/share/Alacritty.desktop" "$APP_DIR/Alacritty.desktop"
install -m 644 "$DEST/share/Alacritty.svg" "$ICON_DIR/Alacritty.svg"
ln -sfn "$DEST/share/alacritty.bash" "$COMPLETION_DIR/alacritty"

# terminfo goes to ~/.terminfo, which ncurses searches by default.
tic -x -e alacritty,alacritty-direct -o "$HOME/.terminfo" "$tmp/src/extra/alacritty.info"

"$BIN_DIR/alacritty" --version
