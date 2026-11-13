OPTIONS="update\nexit"
SELECTION=$(printf "$OPTIONS" | fuzzel --dmenu)

case "$SELECTION" in
"update")
  foot -a foot-floating -e bash -c '
    dir=$1
    before=$(git -C "$dir" rev-parse HEAD)
    git -C "$dir" fetch --quiet && git -C "$dir" reset --hard --quiet "@{upstream}"
    if [ "$before" != "$(git -C "$dir" rev-parse HEAD)" ]; then
      nh os switch "$dir"
    else
      echo "Nothing new on GitHub, skipping the rebuild."
    fi
    echo ""
    read -r -p "Press return to close"
  ' _ "@flakeDir@"
  ;;
esac
