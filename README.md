# prowlrview-plugins

Community plugin registry for [prowlrview](https://github.com/ProwlrBot/prowlrview).

Every plugin lives in its own directory under `categories/` with a `plugin.toml` manifest and a `main.lua` entry point. CI validates Lua syntax and manifest schema on every PR.

## Install a plugin

```sh
# one-shot
curl -fsSL https://raw.githubusercontent.com/ProwlrBot/prowlrview-plugins/main/categories/passive-scan/secret-sniffer/main.lua \
  -o ~/.config/prowlrview/plugins/secret-sniffer.lua

# or: clone and symlink
git clone https://github.com/ProwlrBot/prowlrview-plugins ~/src/prowlrview-plugins
ln -s ~/src/prowlrview-plugins/categories/passive-scan/secret-sniffer/main.lua \
      ~/.config/prowlrview/plugins/secret-sniffer.lua
```

Restart prowlrview or press `r` in the TUI to reload.

## Categories

| Category      | What goes here                                             |
|---------------|------------------------------------------------------------|
| `recon/`      | Subdomain, tech, WAF, takeover detection                   |
| `passive-scan/` | Read-only response/body analysis (secrets, JWT, CORS, …) |
| `active-scan/` | Sends crafted requests (IDOR, SSRF, SQLi heuristics, …)   |
| `graph/`      | Graph decorators, chain detectors, scope guards, exporters |
| `themes/`     | `.toml` color schemes                                      |

## Plugin layout

```
categories/<category>/<plugin-name>/
├── plugin.toml       # manifest (required)
├── main.lua          # entry point (required)
├── README.md         # docs (recommended)
└── test/             # fixtures, optional
```

## Manifest (`plugin.toml`)

```toml
[plugin]
name     = "idor-hunter"
version  = "0.1.0"
author   = "kdairatchi"
license  = "MIT"
summary  = "Flags numeric-ID API paths as IDOR candidates."
category = "active-scan"
events   = ["on_request", "on_response"]
severity_range = ["low", "high"]
tags     = ["idor", "authz", "api"]

[runtime]
engine = "lua"            # lua | wasm
entry  = "main.lua"
min_prowlrview = "0.2.0"
```

## Authoring

Read the [API reference](https://github.com/ProwlrBot/prowlrview/blob/main/plugins/PLUGIN_API.md), or use the Claude skill:

```sh
claude /prowlrview-plugin-author
```

## Contributing

1. Fork, add your plugin under the right category dir.
2. Fill out `plugin.toml`, write `main.lua`.
3. `make validate` (or let CI do it).
4. PR with a screenshot/GIF if it affects the graph visually.

## License

Each plugin declares its own license in `plugin.toml`. The registry itself is MIT.
