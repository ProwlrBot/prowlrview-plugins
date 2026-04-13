#!/usr/bin/env bash
# validate.sh — lints every plugin: syntax-checks Lua, verifies manifest required keys.
set -euo pipefail

cd "$(dirname "$0")/.."
fail=0

echo "::group::lua syntax"
while IFS= read -r -d '' lua; do
  if command -v luac >/dev/null 2>&1; then
    luac -p "$lua" || { echo "SYNTAX FAIL: $lua"; fail=1; }
  else
    echo "skip (no luac): $lua"
  fi
done < <(find categories -name '*.lua' -print0)
echo "::endgroup::"

echo "::group::manifest checks"
while IFS= read -r -d '' toml; do
  for key in name version author license summary category; do
    if ! grep -qE "^$key\s*=" "$toml"; then
      echo "MISSING [$key] in $toml"; fail=1
    fi
  done
done < <(find categories -name 'plugin.toml' -print0)
echo "::endgroup::"

if [ $fail -ne 0 ]; then
  echo "validation FAILED"; exit 1
fi
echo "validation OK"
