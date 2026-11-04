
mmsg dispatch switch_keyboard_layout
sleep 0.1
layout=$(mmsg get keyboardlayout | jq -r '.layout')

notify-send "Keyboard layout" "$layout" -t 1000 -u low -c "osd-text" --hint=string:x-dunst-stack-tag:osd
