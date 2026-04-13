plugin = { name = "cors-misconfig" }

on_response(function(resp)
  local h = resp.headers or {}
  local aco = (h["access-control-allow-origin"] or ""):lower()
  local acc = (h["access-control-allow-credentials"] or ""):lower()
  if aco == "*" and acc == "true" then
    graph:upsert("finding:cors-wildcard-creds:" .. resp.url, "finding",
                 "CORS: * + credentials", resp.url, "high")
    notify("🟠 CORS wildcard+creds: " .. resp.url)
  elseif aco == "null" then
    graph:upsert("finding:cors-null:" .. resp.url, "finding",
                 "CORS: null origin echoed", resp.url, "medium")
  end
end)
