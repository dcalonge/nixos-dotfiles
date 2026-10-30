lock="@flakeDir@/flake.lock"

nix_pkgs=""
if [ -f "$lock" ]; then
  locked=$(jq -r '.nodes.nixpkgs.locked.rev // empty' "$lock")
  branch=$(jq -r '.nodes.nixpkgs.original.ref // "nixos-unstable"' "$lock")
  latest=$(curl -fsS --max-time 10 \
    -H 'Accept: application/vnd.github.sha' \
    "https://api.github.com/repos/NixOS/nixpkgs/commits/$branch" 2>/dev/null)
  if [ -n "$locked" ] && [ -n "$latest" ] && [ "$locked" != "$latest" ]; then
    nix_pkgs="nixpkgs ($branch)"
  fi
fi

# Flatpak updates (only if installed)
if command -v flatpak >/dev/null 2>&1; then
  flatpak_pkgs=$(flatpak remote-ls --updates --columns=application 2>/dev/null)
else
  flatpak_pkgs=""
fi

# Combine lists
all_pkgs=$(printf '%s\n%s\n' "$nix_pkgs" "$flatpak_pkgs" | sed '/^$/d')

# Count
pkg_count=$(printf '%s\n' "$all_pkgs" | grep -c .)

# Tooltip formatting
pkg_list=$(printf '%s\n' "$all_pkgs" | sed '/^$/d; s/$/\\r/' | tr -d '\n')

# Output JSON
printf '{"text":"󰏕 %s", "tooltip":"%s"}\n' "$pkg_count" "$pkg_list"
