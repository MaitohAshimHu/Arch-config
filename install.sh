#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "==> [1/6] Backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
[ -d "$HOME/.config/i3" ] && cp -r "$HOME/.config/i3" "$BACKUP_DIR/"
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/"
[ -d "$HOME/.local/bin" ] && cp -r "$HOME/.local/bin" "$BACKUP_DIR/"

echo "==> [2/6] Installing official repository packages..."
# Filter out EOS-only packages if running on vanilla Arch
if [ -f "$REPO_DIR/packages-pacman.txt" ]; then
    grep -vE '^(eos-|welcome|reflector-simple)' "$REPO_DIR/packages-pacman.txt" | sudo pacman -Syu --needed --noconfirm -
fi

echo "==> [3/6] Checking for AUR helper (yay)..."
if ! command -v yay &> /dev/null; then
    echo "==> Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

if [ -f "$REPO_DIR/packages-aur.txt" ]; then
    echo "==> Installing AUR packages..."
    yay -S --needed --noconfirm - < "$REPO_DIR/packages-aur.txt"
fi

echo "==> [4/6] Deploying configs, scripts, and wallpaper..."
mkdir -p "$HOME/.config/i3" "$HOME/.local/bin" "$HOME/.config/systemd/user" "$HOME/Pictures/wallpapers"

# Copy i3 config and scripts
cp -r "$REPO_DIR/i3/"* "$HOME/.config/i3/"
chmod +x "$HOME/.config/i3/scripts/"* 2>/dev/null || true

# Copy local bin scripts and make executable
cp -r "$REPO_DIR/local-bin/"* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"* 2>/dev/null || true

# Copy zsh config
cp "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Copy wallpaper
cp "$REPO_DIR/wallpaper/hiit.jpg" "$HOME/Pictures/wallpapers/hiit.jpg"

echo "==> [5/6] Setting up systemd timers..."
if [ -d "$REPO_DIR/systemd/user" ]; then
    cp -r "$REPO_DIR/systemd/user/"* "$HOME/.config/systemd/user/"
    systemctl --user daemon-reload
    systemctl --user enable --now speak-time.timer 2>/dev/null || true
fi

echo "==> [6/6] Validating new i3 configuration..."
if i3 -C -c "$HOME/.config/i3/config"; then
    echo "==> Success! Config syntax is valid."
else
    echo "==> Warning: Syntax errors found in ~/.config/i3/config. Check output above."
fi

echo "==> Setup complete! Ensure ~/.local/bin is in your PATH."
