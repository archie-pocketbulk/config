#!/bin/sh
# Run on the Mac mini (needs Homebrew). Tailscale itself is installed by hand, see remote-dev.md.
set -e
brew install zellij helix git gh podman
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
# never sleep, wake on network, restart after power cut
sudo pmset -a sleep 0 disksleep 0 womp 1 autorestart 1
sudo systemsetup -setremotelogin on || echo "enable System Settings > General > Sharing > Remote Login by hand"
mkdir -p ~/.config/zellij
echo "done: sign in to gh ('gh auth login') and claude ('claude') once"
