# Host: Mac mini

The always-on machine where everything runs: Claude Code, editor, builds, tests and dev servers. Stack: Go, SvelteKit (bun), SQLite, DuckDB. All of it runs natively, so no VM or containers are needed.

## Setup

1. Install Tailscale from tailscale.com or the Mac App Store and sign in with the same account as the client.
2. Install Homebrew, clone this repo and run `./mini.sh`. It installs zellij, helix, git, gh, go, bun, duckdb, sqlite and Claude Code, disables sleep, enables wake on network and restart after power loss, and turns on Remote Login (ssh).
3. Run `gh auth login`, then `claude` once and sign in. Paste the printed URL into a browser on the client.

If Remote Login fails to enable, turn it on in System Settings > General > Sharing.

## Daily use

You do not sit at the mini. From the client, `Super+Shift+Return` attaches to zellij session `main`. Open one zellij tab per project (`Ctrl+t`, `n`) and run `claude` in it. The session keeps running when the client disconnects.

## Viewing a running app

Bind the dev server to the mini's tailscale address, not all interfaces, so nothing else on the mini's local network can reach it: `bun run dev --host "$(tailscale ip -4)"` (SvelteKit) or listen on that address in Go. On the client open `http://mini:<port>`, e.g. 5173 for Vite or 8080 for Go.

## Local CI checks

Run the same checks locally as in CI, ideally behind one `make ci` target that the workflow also calls: `go test ./...`, `bun test`, Playwright (`bunx playwright test`), `trivy fs .`, `govulncheck ./...`, `golangci-lint run`, `gitleaks detect`. None need containers on macOS.

## Security

- Do not forward ports on your router. Tailscale needs none.
- Once key login works, set `PasswordAuthentication no` in `/etc/ssh/sshd_config`.
- Use a separate non-admin macOS user for agent work, holding only the project repos, with a `gh` token scoped to those repos. Your main account and its files stay out of reach.
