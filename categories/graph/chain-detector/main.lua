-- chain-detector.lua — promotes findings when they match a known chain pattern.
-- Pairs with your /chain-builder agent: local detection first, remote reasoning second.

plugin = { name = "chain-detector" }

local chains = {
  { a = "idor",          b = "auth-bypass",    label = "IDOR→AuthBypass → full ATO",  sev = "critical" },
  { a = "open-redirect", b = "oauth",          label = "OpenRedirect→OAuth token theft", sev = "high"  },
  { a = "ssrf",          b = "cloud-metadata", label = "SSRF→169.254.169.254 → creds",   sev = "critical" },
  { a = "subdomain-takeover", b = "oauth",     label = "Takeover→OAuth redirect hijack", sev = "critical" },
  { a = "xss",           b = "session",        label = "XSS→ATO via session token",      sev = "high"     },
  { a = "prompt-injection", b = "idor",        label = "Prompt-injection→IDOR exfil",    sev = "high"     },
}

local seen = {}

on_finding(function(f)
  local rule = (f.detail and f.detail.rule or ""):lower()
  for _, c in ipairs(chains) do
    if rule:find(c.a, 1, true) then seen[c.a] = true end
    if rule:find(c.b, 1, true) then seen[c.b] = true end
    if seen[c.a] and seen[c.b] then
      local id = "chain:" .. c.a .. "+" .. c.b
      graph:upsert(id, "finding", c.label, f.id, c.sev)
      graph:tag(id, "CHAIN", "#ff00a0")
      notify("🔗 chain: " .. c.label)
    end
  end
end)
