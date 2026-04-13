plugin = { name = "ssrf-probe" }

local suspicious = { "url=", "uri=", "next=", "redirect=", "callback=", "return=", "image=", "dest=", "continue=" }

on_request(function(req)
  local q = (req.path or ""):lower()
  for _, k in ipairs(suspicious) do
    if q:find(k, 1, true) and q:find("http", 1, true) then
      graph:upsert("finding:ssrf-surface:" .. req.host .. req.path, "finding",
                   "SSRF-like URL param (" .. k .. ")", req.host, "medium")
      graph:tag(req.host, "ssrf-surface", "#ff8c00")
    end
  end
end)
