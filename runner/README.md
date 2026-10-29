# Runner: self-hosted GitHub Actions on the mini

Runs CI on the mini instead of GitHub's machines, so private-repo jobs cost no runner minutes.

**Private repos only.** On a public repo, a pull request from a stranger can run code on this machine through the workflow.

## Setup

1. Create a dedicated non-admin macOS user for the runner so jobs cannot reach your main account's files or credentials.
2. As that user, in the repo go to Settings > Actions > Runners > New self-hosted runner, choose macOS ARM64, and run the download and `./config.sh --url ... --token ...` commands shown.
3. Install it as a background service: `./svc.sh install && ./svc.sh start`.
4. In workflows use `runs-on: self-hosted`.

## Notes

- The runner shares CPU with your development work on the mini.
- Jobs run on macOS, so Linux-only bugs will not show up. Add a GitHub-hosted Linux job if that matters.
- Check GitHub's current pricing for self-hosted runner minutes before relying on it being free.
- Not tested yet.
