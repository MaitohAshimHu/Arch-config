# EndeavourOS + i3 Dotfiles

My personal EndeavourOS + i3wm setup backup.

This repository is intended to restore my customized desktop setup after a fresh EndeavourOS installation or system crash.

## What is backed up

### i3
- i3 configuration
- i3 keybindings
- i3blocks configuration
- i3 helper scripts
- Power/performance controls
- Volume and brightness controls
- CPU/GPU temperature scripts
- Battery and system information scripts
- VPN and network scripts
- Powermenu
- Lock/blur configuration

### Screenshot system

The screenshot scripts are backed up in:

`local-bin/`

Included:

- `screenshot-full`
- `screenshot-window`
- `screenshot-select`

Screenshots are saved to:

`~/Pictures/Screenshots/`

and copied directly to the X clipboard so they can be pasted with:

`Ctrl+V`

### Spoken time

The automatic time announcement is backed up:

`local-bin/speak-time`

Systemd files:

`systemd/user/speak-time.service`

`systemd/user/speak-time.timer`

The timer announces the current time every 30 minutes.

### Wallpaper

My wallpaper is:

`wallpaper/hiit.jpg`

### Shell

My Zsh configuration is backed up in:

`zsh/.zshrc`

### Packages

Installed packages are recorded in:

`packages-pacman.txt`

AUR packages are recorded in:

`packages-aur.txt`

---

# Fresh EndeavourOS Installation

## 1. Install EndeavourOS

Install EndeavourOS normally.

During installation, install/use i3wm.

After booting into the new system, open a terminal.

## 2. Update the system

```bash
sudo pacman -Syu
