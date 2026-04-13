plugin = { name = "waf-fingerprint" }

local probes = {
  { header = "cf-ray",              name = "cloudflare", color = "#f48120" },
  { header = "server",              match = "cloudflare", name = "cloudflare", color = "#f48120" },
  { header = "x-amz-cf-id",         name = "aws-cloudfront", color = "#ff9900" },
  { header = "x-akamai-transformed", name = "akamai", color = "#0099cc" },
  { header = "server",              match = "awselb",  name = "aws-elb", color = "#ff9900" },
  { header = "server",              match = "imperva", name = "imperva", color = "#ff2d55" },
  { header = "x-sucuri-id",         name = "sucuri",   color = "#84c441" },
  { header = "x-powered-by",        match = "Fastly",  name = "fastly",  color = "#ff282d" },
}

on_response(function(resp)
  local h = resp.headers or {}
  for _, p in ipairs(probes) do
    local v = h[p.header]
    if v and (not p.match or v:lower():find(p.match:lower(), 1, true)) then
      graph:tag(resp.url, "waf:" .. p.name, p.color)
      log("waf: " .. p.name .. " at " .. resp.url)
      return
    end
  end
end)
