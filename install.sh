#!/bin/sh
set -e
cd "$(dirname "$0")"
sudo xbps-install -Sy void-repo-nonfree  # vscode and others live in nonfree
xargs -a packages.txt sudo xbps-install -Sy
for s in $(cat services.txt); do
    [ -e "/var/service/$s" ] || sudo ln -s "/etc/sv/$s" /var/service/
done
# symlink home/ into $HOME; real files already there move to <name>.bak
find "$PWD/home" -type f | while read -r src; do
    dst="$HOME/${src#"$PWD/home/"}"
    mkdir -p "$(dirname "$dst")"
    [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak"
    ln -sfn "$src" "$dst"
done
# identity lives in ~/.gitconfig (untracked); shared settings are in ~/.config/git/config
for k in name email; do
    git config --file "$HOME/.gitconfig" user.$k >/dev/null || {
        printf 'git user.%s: ' "$k"; read -r v
        git config --file "$HOME/.gitconfig" user.$k "$v"
    }
done
./tools.sh
sleep 2  # let tailscaled start
tailscale status >/dev/null 2>&1 || sudo tailscale up
