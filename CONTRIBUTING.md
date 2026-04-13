# Contributing plugins

1. Pick a category directory (`recon/`, `passive-scan/`, `active-scan/`, `graph/`, `themes/`). Create a new folder with the plugin's slug (lowercase, hyphens).
2. Add `plugin.toml` and `main.lua` (or `theme.toml` for themes).
3. Run `bash tools/validate.sh` locally (requires `luac`).
4. PR with:
   - A short description of what the plugin detects/does
   - A screenshot if it affects the graph visually
   - Scope of events it hooks

## Rules of thumb

- **Passive scans never mutate requests.** If it rewrites, it goes in `active-scan/` or `graph/`.
- **No network calls from plugins.** Plugins react to what the proxy/adapter feeds them. If you need to hit the network, propose a core API first.
- **No secrets in plugins.** Not in code, not in comments, not in screenshots.
- **Severity budget.** Critical is for things that actually compromise something. Every `notify("🔴 ...")` that isn't critical trains hunters to ignore alerts.

## Plugin API

See [prowlrview/plugins/PLUGIN_API.md](https://github.com/ProwlrBot/prowlrview/blob/main/plugins/PLUGIN_API.md).

## License

By contributing you agree to release your plugin under the license listed in its `plugin.toml` (MIT recommended). The registry as a whole is MIT.
