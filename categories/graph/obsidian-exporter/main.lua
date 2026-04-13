-- obsidian-exporter.lua — stream findings into the Obsidian hunt journal.
-- Needs filesystem write access; when prowlrview adds an `fs:` safe API
-- this script switches to it. Until then, it uses `log()` + the user's
-- prowlrview --snapshot hook.

plugin = { name = "obsidian-exporter" }

on_finding(function(f)
  local sev = f.severity or "info"
  local line = string.format("- **%s** `%s` — %s → %s", sev, f.detail.rule or "?", f.detail.matched or "", f.id)
  log("[journal] " .. line)
  -- tag for downstream export sweep
  graph:tag(f.id, "journal", "#00eaff")
end)
