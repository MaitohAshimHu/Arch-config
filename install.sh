#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "==> [1/6] Backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
[ -d "$HOME/.config/i3" ] && cp -r "$HOME/.config/i3" "$BACKUP_DIR/"
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/"
[ -d "$HOME/.local/bin" ] && cp -r "$HOME/.local/bin" "$BACKUP_DIR/"
[ -d "$HOME/.config/systemd/user" ] && cp -r "$HOME/.config/systemd/user" "$BACKUP_DIR/"

echo "==> [2/6] Installing official repository packages..."
if [ -f "$REPO_DIR/packages-pacman.txt" ]; then
    grep -vE '^(eos-|welcome|reflector-simple)' "$REPO_DIR/packages-pacman.txt" | \
    sudo pacman -Syu --needed --noconfirm - || echo "==> Notice: Some pacman packages skipped or unavailable."
fi

echo "==> [3/6] Ensuring AUR helper (yay) is installed..."
if ! command -v yay &> /dev/null; then
    echo "==> yay not found. Building yay from AUR..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
fi

if [ -f "$REPO_DIR/packages-aur.txt" ]; then
    echo "==> Installing AUR packages..."
    yay -S --needed --noconfirm - < "$REPO_DIR/packages-aur.txt" || echo "==> Notice: Some AUR packages could not be installed."
fi

echo "==> [4/6] Deploying configs, scripts, and wallpaper..."
mkdir -p "$HOME/.config/i3" "$HOME/.local/bin" "$HOME/.config/systemd/user" "$HOME/Pictures/wallpapers"

# Deploy i3 config and helper scripts
cp -r "$REPO_DIR/i3/"* "$HOME/.config/i3/"
chmod +x "$HOME/.config/i3/scripts/"* 2>/dev/null || true

# Deploy custom local binaries and scripts
cp -r "$REPO_DIR/local-bin/"* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"* 2>/dev/null || true

# Deploy shell config
if [ -f "$REPO_DIR/zsh/.zshrc" ]; then
    cp "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

# Deploy wallpaper
if [ -f "$REPO_DIR/wallpaper/hiit.jpg" ]; then
    cp "$REPO_DIR/wallpaper/hiit.jpg" "$HOME/Pictures/wallpapers/hiit.jpg"
fi

echo "==> [5/6] Configuring systemd user services and timers..."
if [ -d "$REPO_DIR/systemd/user" ]; then
    cp -r "$REPO_DIR/systemd/user/"* "$HOME/.config/systemd/user/"
    systemctl --user daemon-reload
    if [ -f "$HOME/.config/systemd/user/speak-time.timer" ]; then
        systemctl --user enable --now speak-time.timer 2>/dev/null || true
    fi
fi

echo "==> [6/6] Validating new i3 configuration..."
if i3 -C -c "$HOME/.config/i3/config"; then
    echo "==> Success: i3 configuration syntax is valid!"
else
    echo "==> Warning: Syntax errors found in ~/.config/i3/config. Review above messages."
fi

echo "=========================================================="
echo " Setup complete! Reload i3 (Mod+Shift+r) to apply changes."
echo " Ensure ~/.local/bin is in your PATH in ~/.zshrc."
echo "=========================================================="
