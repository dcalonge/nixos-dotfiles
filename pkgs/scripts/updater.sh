OPTIONS="update\nexit"
SELECTION=$(printf "$OPTIONS" | fuzzel --dmenu)

case "$SELECTION" in
"update")
  foot -a foot-floating -e bash -c '
    nh os switch --update "$1" &&
      flatpak update -y
    echo ""
    read -r -p "Press return to close"
  ' _ "@flakeDir@"
  ;;
esac
