# My EndeavourOS Dotfiles

Personal EndeavourOS + i3 configuration backup.

## Included

- i3 configuration and keybindings
- i3blocks configuration
- i3 helper scripts
- Screenshot scripts (save + clipboard)
- Spoken-time script
- systemd user service/timer for spoken time
- zsh configuration
- `hiit.jpg` wallpaper
- Pacman package list
- AUR package list
- Basic system/power/audio information

## Fresh-install restore

1. Install EndeavourOS and the packages listed in `packages-pacman.txt`.
2. Install AUR packages listed in `packages-aur.txt`.
3. Copy the backed-up configuration files into their corresponding locations.
4. Make scripts executable:
   `chmod +x ~/.local/bin/* ~/.config/i3/scripts/*`
5. Reload i3:
   `i3-msg reload`
6. Reload user systemd:
   `systemctl --user daemon-reload`
7. Enable the spoken-time timer:
   `systemctl --user enable --now speak-time.timer`

This repository intentionally does not contain passwords, cookies, SSH private keys, or other credentials.
