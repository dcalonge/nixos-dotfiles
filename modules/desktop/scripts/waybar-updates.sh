dir="@flakeDir@"

entries=()

# Flake inputs updated on GitHub (by the weekly workflow) but not pulled yet
export GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes"
if timeout 30 git -C "$dir" fetch --quiet 2>/dev/null; then
  remote_lock=$(git -C "$dir" show '@{upstream}:flake.lock' 2>/dev/null)
  if [ -n "$remote_lock" ]; then
    while IFS= read -r input; do
      [ -n "$input" ] && entries+=("flake input: $input")
    done < <(jq -rn --slurpfile here "$dir/flake.lock" --argjson there "$remote_lock" '
      def hash($lock; $name):
        ($lock.nodes[($lock.nodes.root.inputs[$name] // "")] // {}).locked.narHash;
      $here[0] as $h
      | $there.nodes.root.inputs | keys[]
      | select(hash($h; .) != hash($there; .))
      | "flake input: \(.)"
    ' 2>/dev/null)
    if [ "$(jq -r '.nodes.root.locked.narHash // empty' "$dir/flake.lock")" != "$(jq -r '.nodes.root.locked.narHash // empty' <<<"$remote_lock")" ]; then
      entries+=("flake.lock")
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
