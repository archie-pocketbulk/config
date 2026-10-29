# Remote dev

The laptop is a thin client: foot + ssh. Everything heavy (Claude Code, builds, containers, dev servers) runs on the Mac mini, which stays on. The laptop only sends keystrokes and draws text, so battery use is minimal.

```
laptop (foot -> ssh) --tailscale--> mini (zellij: claude, helix, dev servers)
laptop browser -------tailscale--> http://mini:3000
```

Tailscale gives both machines private addresses on one encrypted network, reachable from any wifi or mobile hotspot, with no router ports opened.

## Setup

**1. Mini** (once, at the machine or over screen sharing)
1. Install Tailscale from tailscale.com or the Mac App Store, sign in with the same account as the laptop.
2. Install Homebrew, then run `remote/mini.sh` from a clone of this repo. It installs zellij, helix, git, gh, podman and Claude Code, stops sleep and enables Remote Login.
3. `gh auth login`, then run `claude` once and sign in (paste the URL it prints into the laptop browser).

**2. Laptop**
1. `./install.sh` already installs and joins tailscale. Run `tailscale status` and note the mini's name.
2. Run `remote/laptop.sh`. It adds `Host mini` to `~/.ssh/config` (kept out of the repo, it holds your username) and copies your key over.
3. If `mini` does not resolve, use the mini's 100.x address as the hostname instead.

## Daily use

| Key | Result |
|-----|--------|
| `Super+Shift+Return` | terminal attached to zellij session `main` on the mini |
| `Super+Return` | local terminal, no network needed |

Inside the mini session, open one zellij tab per project (`Ctrl+t`, `n`) and run `claude` in it. Close the lid, switch networks, or lose wifi: the session keeps running, and the next `Super+Shift+Return` reattaches.

## Viewing your running app

Start the dev server on the mini listening on all interfaces, for example `vite --host`, `next dev -H 0.0.0.0`, or `python -m http.server`. On the laptop open `http://mini:3000` (your port). It is only reachable over your tailnet.

## Battery

- Stay in the terminal. Browsers and vscode are the biggest local drains.
- `tlp` (already enabled) handles the rest. The idle config blanks the screen after 10 minutes.
- Do not run Claude, builds or containers locally while on battery.

## Security

- The laptop's ssh key (no passphrase) is a login to the mini. Keep the laptop disk encrypted.
- Do not forward mini ports on your router. Tailscale needs none.
- Mini: turn off password ssh logins once the key works (`PasswordAuthentication no` in `/etc/ssh/sshd_config`).
