plugin = { name = "takeover-hunter" }

local fingerprints = {
  { re = "There isn't a GitHub Pages site here",             service = "github-pages", sev = "high"     },
  { re = "No such app",                                       service = "heroku",       sev = "high"     },
  { re = "NoSuchBucket",                                      service = "aws-s3",       sev = "critical" },
  { re = "The specified bucket does not exist",               service = "aws-s3",       sev = "critical" },
  { re = "Fastly error: unknown domain",                      service = "fastly",       sev = "high"     },
  { re = "404 Not Found.*Server: Microsoft%-Azure",           service = "azure",        sev = "high"     },
  { re = "Do you want to register .*%.wordpress%.com",        service = "wordpress",    sev = "high"     },
  { re = "The requested URL was not found on this server%. Nginx", service = "nginx-unclaimed", sev = "medium" },
  { re = "project not found",                                 service = "readthedocs",  sev = "medium"   },
}

on_response(function(resp)
  for _, fp in ipairs(fingerprints) do
    if resp:matches(fp.re) then
      graph:upsert("finding:takeover:" .. fp.service .. ":" .. resp.url, "finding",
                   "Subdomain takeover: " .. fp.service, resp.url, fp.sev)
      graph:tag(resp.url, "takeover:" .. fp.service, "#ff0066")
      notify("🔴 takeover candidate (" .. fp.service .. "): " .. resp.url)
      return
    end
  end
end)
