#!/bin/sh
# Run on the laptop: add ssh host "mini" and install your key on it.
set -e
printf 'Mini tailnet name or 100.x IP: '; read -r host
printf 'Mini username: '; read -r user
mkdir -p ~/.ssh/sockets && chmod 700 ~/.ssh
if ! grep -q '^Host mini$' ~/.ssh/config 2>/dev/null; then
    cat >> ~/.ssh/config <<CFG

Host mini
    HostName $host
    User $user
    ServerAliveInterval 30
    ServerAliveCountMax 3
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 10m
CFG
fi
[ -e ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
ssh-copy-id mini
echo "done: try 'ssh mini', then Super+Shift+Return"
