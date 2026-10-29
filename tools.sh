#!/bin/sh
# Language tooling that is not in xbps (or is, but not in packages.txt).
set -e
command -v go >/dev/null || sudo xbps-install -Sy go
command -v bun >/dev/null || curl -fsSL https://bun.sh/install | bash
# cargo and uv come from packages.txt
