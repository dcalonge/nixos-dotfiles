OPTIONS="update\nexit"
SELECTION=$(printf "$OPTIONS" | fuzzel --dmenu)

case "$SELECTION" in
"update")
  foot -a foot-floating -e bash -c '
    dir=$1
    # The remote lock is the source of truth; drop local edits so the pull
    # cannot fail on them.
    git -C "$dir" restore --source=HEAD --staged --worktree -- flake.lock
    # Only rebuild when GitHub has commits this checkout does not have yet
    if git -C "$dir" fetch --quiet &&
      [ "$(git -C "$dir" rev-list --count "HEAD..@{upstream}")" -gt 0 ]; then
      git -C "$dir" pull --ff-only && nh os switch "$dir"
    else
      echo "Nothing new on GitHub, skipping the rebuild."
    fi
    echo ""
    flatpak update -y
    echo ""
    read -r -p "Press return to close"
  ' _ "@flakeDir@"
  ;;
esac
