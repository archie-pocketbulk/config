# Client: Void + sway laptop

The thin client of the [remote dev setup](../README.md). Terminal-first, minimal compute.

Void + runit + sway on a ThinkPad. Wifi: `wpa_supplicant` + `dhcpcd`.

## Install

```
git clone https://github.com/archie-pocketbulk/config && cd config/client && ./install.sh
```

Needs network and sudo. It does, in order:
1. enables the nonfree repo, installs `packages.txt`
2. enables `services.txt` (runit)
3. symlinks `home/` into `$HOME` (existing files move to `*.bak`)
4. asks for git name and email if `~/.gitconfig` has none
5. runs `tools.sh` (go, bun)
6. `tailscale up` if not already connected (opens a login link)

## Manual steps (secrets, not in repo)

```
wpa_passphrase "ssid" "password" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
sudo sv restart wpa_supplicant
rbw config set email <email> && rbw login
gh auth login
```

## Files

| Path | What |
|------|------|
| `packages.txt` | `xbps-query -m`, minus base/kernel/grub/live/build leftovers |
| `services.txt` | `/var/service` minus agetty |
| `tools.sh` | go, bun (cargo and uv are in `packages.txt`) |
| `laptop.sh` | ssh setup for the remote host |
| `home/` | sway, foot, git, `.bashrc`, `.local/bin/rbw-*` |

Refresh the lists:
```
xbps-query -m | sed 's/-[^-]*$//' | grep -vxE 'base-system|linux|grub-.*|void-live-audio|void-docs-browse' > packages.txt
ls /var/service | grep -v '^agetty-tty' > services.txt
```

## Packages

| Area | Packages |
|------|----------|
| Desktop | sway foot wofi i3status swaylock swayidle grim slurp wl-clipboard |
| Audio | pipewire wireplumber playerctl |
| Hardware | brightnessctl tlp powertop acpid |
| Editors | helix vscode nano abiword |
| Terminal | zellij fzf btop jq fd bat eza |
| Browsers | qutebrowser chromium |
| Apps | aerc task taskwarrior-tui rbw |
| Dev | git base-devel cargo uv podman podman-compose rsync github-cli |
| Network | tailscale chrony waypipe wol |

## Tools

Tools are picked lean, prioritising TUI and CLI over GUI, so sway only tiles terminals. vscode, chromium, qutebrowser and abiword are optional extras.

| Tool | What it does |
|------|--------------|
| `helix` | modal editor (`Super+c`) |
| `nano` | simple fallback editor |
| `zellij` | panes, tabs and sessions inside the terminal |
| `aerc` | email client |
| `rbw` + `fzf` | Bitwarden password picker (`Super+p`) |
| `task` + `taskwarrior-tui` | tasks and tickets |
| `btop` | system monitor |
| `fzf` | fuzzy finder |
| `fd`, `bat`, `eza` | faster `find`, `cat`, `ls` |
| `jq` | JSON processor |
| `podman` + `podman-compose` | containers, Docker-compatible |
| `gh` | GitHub from the terminal |
| `tailscale` | VPN to your other machines |

## Keys (sway)

| Key | Action |
|-----|--------|
| `Super+Return` | terminal |
| `Super+Shift+Return` | terminal on the remote dev box (falls back to local) |
| `Super+d` | launcher |
| `Super+c` | helix |
| `Super+p` | Bitwarden entry to clipboard |
| `Super+Shift+w` | wifi back on |
| `Print` | region screenshot to `~/Pictures` |

## Remote dev box

`Super+Shift+Return` runs `dev-term`: it attaches to the zellij session `main` on the host `mini` and falls back to local zellij if `mini` is unreachable. `Super+Return` is always local.

One-time setup, after the [host](../host/README.md) exists: run `./laptop.sh`. It adds `Host mini` to `~/.ssh/config` (kept out of the repo, it holds your username), generates a key if needed, and copies it to the host. If `mini` does not resolve, give it the host's 100.x tailscale address.

The laptop key has no passphrase, because `dev-term` checks reachability non-interactively. It is a login to the host, so keep the laptop disk encrypted.

## Logins that redirect to localhost

Some tools on the mini finish login by redirecting the browser to `http://localhost:<port>/callback`. On the laptop that `localhost` is the wrong machine. `chromium-mini` opens Chromium with its traffic tunnelled through the mini, so `localhost` means the mini. The browser itself still runs on the laptop, in its own profile.

## Bitwarden unlock

`rbw` uses `rbw-pinentry`, which reads the master password from the kernel keyring. After each boot, `Super+p` runs `rbw-save` once to ask for it. The keyring is memory only and clears on reboot. If you change the master password, run `rbw-save` again.
