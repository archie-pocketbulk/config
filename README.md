# Ultra-low-compute dev experiment

Can a laptop be just a screen and a keyboard? This repo tests that: all development compute runs on a Mac mini that stays on, and the laptop only types into it.

```
laptop (foot -> ssh) --tailscale--> mac mini (zellij: Claude Code, helix, builds, tests, dev servers)
laptop browser -------tailscale--> http://mini:<port>      mac mini (GitHub Actions runner)
```

## Why

- **Power efficiency.** An Apple Silicon mini idles at single-digit watts and does heavy work far more efficiently per watt than a laptop on battery. Compute moves from the device that has a battery to the one that doesn't.
- **Laptop battery.** The laptop runs a window manager, a terminal and wifi. It never builds, tests, runs a browser engine for the app, or hosts Claude. Battery life is limited by the screen, not the workload.
- **Faster, more consistent network.** The mini sits on wired ethernet and does the heavy traffic: git, package downloads, model API calls. The laptop's wifi link carries only keystrokes and text, so a weak or flaky connection barely matters, and zellij keeps the session alive through drops.
- **Always on.** Long agent runs, tests and CI finish while the laptop is shut. Reattach later and carry on.
- **Wake as a fallback.** The mini is set to never sleep. It can also wake on network traffic, but Wake-on-LAN only works from the same local network.

## The experiment

Any machine with a screen, keyboard and ssh should be a usable dev machine. Success looks like: more battery hours, no waiting on local builds, work that survives disconnects. The cost is that development needs the network: no connection means no mini, and the laptop falls back to local zellij only. The mini is also a single point of failure, so power cuts and internet outages stop work.

I accept that trade. Development already needs the internet: AI coding, scanning and CI all run in the cloud, and I am rarely far from home. With no connection, reading docs and code is the better use of the time anyway, so the offline fallback stays minimal.

## Layout

| Folder | Role |
|--------|------|
| [`client/`](client/README.md) | the laptop: Void Linux + sway config, packages, install script, ssh setup |
| [`host/`](host/README.md) | the Mac mini: dev tools, always-on settings, tailscale, dev servers |
| [`runner/`](runner/README.md) | the Mac mini as a self-hosted GitHub Actions runner (private repos only) |

## Order of setup

1. [Host](host/README.md): install tailscale, run `host/mini.sh`.
2. [Client](client/README.md): run `client/install.sh`, then `client/laptop.sh`.
3. [Runner](runner/README.md), optional: register the mini for CI.
