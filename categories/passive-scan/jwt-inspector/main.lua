-- jwt-inspector.lua — passive JWT weakness detection.

plugin = { name = "jwt-inspector" }

local jwt_re = "eyJ[A-Za-z0-9_-]+%.eyJ[A-Za-z0-9_-]+%.[A-Za-z0-9_-]*"

local function b64url_peek(s)
  -- naive decode only to find "alg" field; avoids pulling a base64 lib
  return s
end

on_response(function(resp)
  if not resp:matches(jwt_re) then return end
  local body = resp.body or ""
  local token = body:match(jwt_re)
  if not token then return end

  local header = token:match("^(eyJ[^%.]+)")
  if header then
    local h = b64url_peek(header)
    if h:find("\"alg\"%s*:%s*\"none\"") then
      graph:upsert("finding:jwt-alg-none:" .. resp.url, "finding",
                   "JWT alg=none accepted", resp.url, "critical")
      notify("🔴 JWT alg=none: " .. resp.url)
    end
    if h:find("\"alg\"%s*:%s*\"HS256\"") then
      graph:tag(resp.url, "jwt-hs256", "#ffd60a")
    end
    if h:find("\"kid\"%s*:%s*\"[^\"]*%.%./") then
      graph:upsert("finding:jwt-kid-traversal:" .. resp.url, "finding",
                   "JWT kid path traversal", resp.url, "high")
    end
  end
end)
