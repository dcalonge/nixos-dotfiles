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
      echo "Nothing new on GitHub, checking Flatpak."
      if [ -n "$(flatpak remote-ls --updates --columns=application 2>/dev/null)" ]; then
        flatpak update -y
      else
        echo "No Flatpak updates."
      fi
    fi
    echo ""
    read -r -p "Press return to close"
  ' _ "@flakeDir@"
  ;;
esac
