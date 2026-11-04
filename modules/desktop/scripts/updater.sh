OPTIONS="update\nexit"
SELECTION=$(printf "$OPTIONS" | fuzzel --dmenu)

case "$SELECTION" in
"update")
  foot -a foot-floating -e bash -c '
    git -C "$1" pull --ff-only &&
      nh os switch "$1" &&
      flatpak update -y
    echo ""
    read -r -p "Press return to close"
  ' _ "@flakeDir@"
  ;;
esac
