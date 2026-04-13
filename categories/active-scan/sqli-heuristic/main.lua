plugin = { name = "sqli-heuristic" }

local sigs = {
  "mysql_fetch", "You have an error in your SQL syntax",
  "ORA%-%d%d%d%d%d", "PG::SyntaxError", "SQLSTATE%[", "SQLite3::",
  "Microsoft OLE DB Provider for SQL", "Unclosed quotation mark",
}

on_response(function(resp)
  for _, s in ipairs(sigs) do
    if resp:matches(s) then
      graph:upsert("finding:sqli-error:" .. resp.url, "finding",
                   "SQL error leak: " .. s, resp.url, "high")
      notify("🟠 SQL error at " .. resp.url)
      return
    end
  end
end)
