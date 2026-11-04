lock="@flakeDir@/flake.lock"

entries=()

# Nixpkgs input update check
if [ -f "$lock" ]; then
  locked=$(jq -r '.nodes.nixpkgs.locked.rev // empty' "$lock")
  branch=$(jq -r '.nodes.nixpkgs.original.ref // "nixos-unstable"' "$lock")
  latest=$(curl -fsS --max-time 10 \
    -H 'Accept: application/vnd.github.sha' \
    "https://api.github.com/repos/NixOS/nixpkgs/commits/$branch" 2>/dev/null)
  if [ -n "$locked" ] && [ -n "$latest" ] && [ "$locked" != "$latest" ]; then
    # Try to list actual package names that would upgrade
    nix_names=$(nix-env -u --dry-run 2>/dev/null \
      | sed -n 's/^would upgrade \([^ ]*\).*/\1/p' \
      | tr '\n' ' ' | sed 's/ $//')
    if [ -n "$nix_names" ]; then
      entries+=("nixpkgs ($branch): $nix_names")
    else
      entries+=("nixpkgs ($branch)")
    fi
  fi
fi

# Flatpak updates (only if installed)
if command -v flatpak >/dev/null 2>&1; then
  while IFS= read -r app; do
    [ -n "$app" ] && entries+=("flatpak: $app")
  done < <(flatpak remote-ls --updates --columns=application 2>/dev/null)
fi

pkg_count=${#entries[@]}

# Tooltip: one entry per line
if [ "${#entries[@]}" -gt 0 ]; then
  tooltip=$(printf '%s\n' "${entries[@]}")
else
  tooltip=""
fi

# Escape for JSON
tooltip_json=$(printf '%s' "$tooltip" | jq -Rs .)

printf '{"text":"󰏕 %s", "tooltip":%s}\n' "$pkg_count" "$tooltip_json"
