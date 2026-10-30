{
  config,
  lib,
  pkgs,
  ...
}:
let
  scripts = pkgs.dotfiles-scripts;
  pkill = lib.getExe' pkgs.procps "pkill";
  bluetoothctl = lib.getExe' pkgs.bluez "bluetoothctl";
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      reload_style_on_change = true;
      toggle = true;
      layer = "top";
      position = "top";
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      spacing = 4;
      height = 24;

      modules-left = [ "ext/workspaces" ];
      modules-center = [
        "clock"
        "custom/weather"
        "custom/updates"
        "privacy"
      ];
      modules-right = [
        "keyboard-state"
        "group/tray-expander"
        "wireplumber"
        "backlight"
        "bluetooth"
        "network"
        "battery"
      ];

      "ext/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons.active = "󱓻";
      };

      clock = {
        format = "{:L%B %d %H:%M}";
        tooltip = false;
      };

      tray = {
        spacing = 16;
        reverse-direction = true;
        icon-size = 14;
        show-passive-items = false;
      };

      privacy = {
        icon-size = 12;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
          }
          {
            type = "audio-in";
            tooltip = true;
          }
        ];
      };

      network = {
        format-icons = {
          wifi = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          ethernet = "󰈀";
          disabled = "󰤮";
          disconnected = "󰤫";
        };
        format-wifi = "{icon}";
        format-ethernet = "{icon}";
        format-disconnected = "{icon}";
        format-disabled = "{icon}";
        interval = 5;
        tooltip-format = "{essid}\t{gwaddr}";
        tooltip-format-disconnected = "Disconnected";
        tooltip-format-disabled = "Disabled";
        on-click-right = "${lib.getExe' pkgs.util-linux "rfkill"} toggle wifi";
        on-click = "${pkill} fuzzel || ${lib.getExe' pkgs.iwmenu "iwmenu"} -l fuzzel";
        tooltip = true;
        max-length = 20;
      };

      bluetooth = {
        format-on = "󰂯";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-no-controller = "󰂯";
        tooltip = true;
        tooltip-format = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias} | Battery: {device_battery_percentage}%";
        on-click-right = "${bluetoothctl} show | ${lib.getExe' pkgs.gnugrep "grep"} -q 'Powered: yes' && ${bluetoothctl} power off || ${bluetoothctl} power on";
        on-click = "${pkill} fuzzel || ${lib.getExe' pkgs.bzmenu "bzmenu"} -l fuzzel";
      };

      wireplumber = {
        format = "{format_source} {icon}";
        format-icons = [
          "󰕿"
          "󰖀"
          "󰕾"
          "󰝝"
        ];
        format-muted = "󰖁";
        format-source = "󰍬 ";
        format-source-muted = "";
        on-click-right = "${lib.getExe' config.programs.foot.package "foot"} -a foot-floating -e ${lib.getExe' pkgs.pulsemixer "pulsemixer"}";
        on-click = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        reverse-scrolling = true;
        tooltip = true;
        tooltip-format = "Volume: {volume}%";
        scroll-step = 5;
      };

      backlight = {
        format = "{icon}";
        format-icons = [
          "󰃞"
          "󰃝"
          "󰃟"
          "󰃠"
        ];
        reverse-scrolling = true;
        tooltip = true;
        scroll-step = 5;
        tooltip-format = "Brightness: {percent}%";
      };

      battery = {
        interval = 5;
        states.critical = 10;
        format = "{icon} {capacity}%";
        format-icons = {
          default = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          charging = [
            "󰢟"
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
        };
        format-plugged = "󰚥";
        format-critical = "󰂃 {capacity}%";
        tooltip = true;
        tooltip-format = "Charge: {capacity}%";
        tooltip-format-charging = "Charging: {capacity}%";
      };

      "custom/updates" = {
        format = "{}";
        return-type = "json";
        tooltip = true;
        interval = 3600;
        exec = "${scripts.waybar-updates}/bin/waybar-updates";
        on-click = "${scripts.updater}/bin/updater";
      };

      "custom/weather" = {
        format = "{}";
        return-type = "json";
        tooltip = true;
        interval = 900;
        exec = "${scripts.waybar-weather}/bin/waybar-weather Soria";
        signal = 8;
        on-click = "${pkill} -SIGRTMIN+8 waybar";
      };

      "group/tray-expander" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 600;
          children-class = "tray-group-item";
        };
        modules = [
          "custom/expand-icon"
          "tray"
        ];
      };

      "custom/expand-icon" = {
        format = "";
        tooltip = false;
      };

      keyboard-state = {
        capslock = true;
        format.capslock = "{icon}";
        format-icons = {
          locked = "Caps ";
          unlocked = "";
        };
      };
    };

    style = ''
      @import url("file://${config.xdg.configHome}/waybar/colors.css");

      * {
        background-color: @surface;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 13px;
      }

      /* === GLOBAL MODULE TEXT COLOR === */
      #clock,
      #custom-menu,
      #tray,
      #network,
      #bluetooth,
      #wireplumber,
      #backlight,
      #custom-updates,
      #privacy,
      #custom-power,
      #battery,
      #custom-expand-icon,
      #group-tray-expander,
      #keyboard-state,
      #workspaces button {
        color: @on-surface;
      }

      .modules-left {
        margin-left: 12px;
      }

      .modules-right {
        margin-right: 12px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 2px;
      }

      #window {
        color: @on-surface-variant;
      }

      #workspaces button.hidden {
        color: @on-surface-variant;
      }

      /* === MODULE SPACING === */
      #clock,
      #custom-menu,
      #tray,
      #network,
      #bluetooth,
      #wireplumber,
      #backlight,
      #custom-updates,
      #privacy,
      #custom-power,
      #custom-expand-icon,
      #group-tray-expander,
      #custom-expand-icon,
      #keyboard-state,
      #battery {
        min-width: 12px;
        margin: 0 6px;
      }

      /* === STATES === */
      #battery.critical {
        color: @error;
      }

      /* === HOVER EFFECT === */
      #custom-updates:hover,
      #network:hover,
      #bluetooth:hover,
      #wireplumber:hover,
      #workspaces button:hover {
        background: transparent;
        opacity: 0.7;
      }

      /* === TOOLTIP === */
      tooltip {
        background: @surface;
        color: @on-surface;
      }
    '';
  };
}
