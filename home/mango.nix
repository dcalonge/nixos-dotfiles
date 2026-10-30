{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  tags = builtins.genList (i: toString (i + 1)) 9;
  vts = builtins.genList (i: toString (i + 1)) 12;

  bin = pkg: name: "${pkg}/bin/${name}";
  script = name: bin pkgs.dotfiles-scripts.${name} name;
  foot = bin config.programs.foot.package "foot";
  fuzzel = bin config.programs.fuzzel.package "fuzzel";
  pkill = bin pkgs.procps "pkill";
  systemctl = bin pkgs.systemd "systemctl";
  playerctl = bin pkgs.playerctl "playerctl";
  wlr-randr = bin pkgs.wlr-randr "wlr-randr";
  qalculate = bin pkgs.qalculate-gtk "qalculate-gtk";
in
{
  imports = [ inputs.mango.hmModules.mango ];

  wayland.windowManager.mango = {
    enable = true;
    package = pkgs.mango;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    # Must be non-empty: the systemd activation runs from autostart.sh
    autostart_sh = "true";

    settings = {
      xwayland_persistence = 0;

      animations = 0;
      layer_animations = 0;
      border_px = 2;
      monocle_no_border = 1;
      gap_inner_horizontal = 8;
      gap_inner_vertical = 8;
      gap_outer_horizontal = 8;
      gap_outer_vertical = 8;
      smart_gaps = 0;
      monocle_no_gap = 1;
      sloppy_focus = 1;

      tab_bar_decorate_font_desc = "JetBrainsMono Nerd Font 11";
      tab_bar_height = 20;
      tab_bar_decorate_border_width = 0;
      tab_bar_decorate_corner_radius = 0;

      tag_num = 9;
      default_master_factor = 0.55;
      default_master_count = 1;
      new_is_master = 1;

      window_rule = [
        "title:Open File,is_floating:1"
        "title:Open Folder,is_floating:1"
        "app_id:qalculate-gtk,is_floating:1"
        "app_id:zathura,is_floating:1"
        "app_id:imv,is_floating:1"
        "app_id:foot-floating,is_floating:1"
      ];

      monitor_rule = "name:^eDP-1$,scale:1.2";

      repeat_rate = 25;
      repeat_delay = 600;
      xkb_rules_layout = "es";

      disable_trackpad = 0;
      tap_to_click = 1;
      tap_and_drag = 1;
      drag_lock = 1;
      trackpad_natural_scrolling = 1;
      trackpad_disable_while_typing = 1;
      trackpad_left_handed = 0;
      trackpad_middle_button_emulation = 0;
      trackpad_scroll_method = 1; # two-finger
      trackpad_click_method = 0;
      trackpad_send_events_mode = 0; # enabled
      trackpad_accel_profile = 2; # adaptive
      trackpad_accel_speed = 0.0;
      button_map = 0;

      bind = [
        "SUPER,Left,focusdir,left"
        "SUPER,Right,focusdir,right"
        "SUPER,Up,focusstack,prev"
        "SUPER,Down,focusstack,next"

        "SUPER+SHIFT,Left,exchange_client,left"
        "SUPER+SHIFT,Right,exchange_client,right"
        "SUPER+SHIFT,Up,exchange_client,up"
        "SUPER+SHIFT,Down,exchange_client,down"

        "SUPER,plus,incnmaster,+1"
        "SUPER,minus,incnmaster,-1"
        "SUPER+CTRL,Right,setmfact,+0.05"
        "SUPER+CTRL,Left,setmfact,-0.05"

        "SUPER+SHIFT,Return,zoom"
        "SUPER,Tab,view,-1"
        "SUPER+SHIFT,r,reload_config"

        "SUPER,t,setlayout,tile"
        "SUPER,m,setlayout,monocle"
        "SUPER+SHIFT,space,togglefloating"
        "SUPER,f,togglefullscreen"

        "SUPER,0,view,0"
        "SUPER+SHIFT,equal,tag,0"
      ]
      ++ builtins.concatMap (n: [
        "SUPER,${n},view,${n}"
        "SUPER+CTRL,${n},toggleview,${n}"
        "SUPER+SHIFT,${n},tag,${n}"
        "SUPER+CTRL+SHIFT,${n},toggletag,${n}"
      ]) tags
      ++ [
        "SUPER,comma,focusmon,left"
        "SUPER+SHIFT,comma,tagmon,left"
        "SUPER,period,focusmon,right"
        "SUPER+SHIFT,period,tagmon,right"

        "SUPER,q,killclient"
        "SUPER+CTRL,q,spawn,${systemctl} suspend"

        "SUPER,Return,spawn,${foot}"
        "SUPER,b,spawn,${lib.getExe pkgs.helium}"
        "SUPER,Space,spawn_shell,${pkill} fuzzel || ${fuzzel}"
        "SUPER,r,spawn_shell,${pkill} fuzzel || ${script "wlr-menu"}"
        "SUPER,e,spawn,${foot} -e ${bin config.programs.yazi.package "yazi"}"
        "SUPER,n,spawn,${foot} -T neovim -e ${bin config.programs.neovim.finalPackage "nvim"}"
        "SUPER,p,spawn,${foot} -a foot-floating -e ${bin pkgs.pulsemixer "pulsemixer"}"
        "SUPER,c,spawn,${qalculate}"
        "SUPER,h,spawn,${foot} -T btop -e ${bin config.programs.btop.package "btop"}"
        "SUPER+SHIFT,a,spawn,${foot} -a foot-floating -e ${bin pkgs.bluetuith "bluetuith"}"
        "SUPER,w,spawn_shell,${pkill} fuzzel || ${bin pkgs.iwmenu "iwmenu"} -l fuzzel"
        "SUPER,a,spawn_shell,${pkill} fuzzel || ${bin pkgs.bzmenu "bzmenu"} -l fuzzel"
        "SUPER,v,spawn_shell,${pkill} fuzzel || ${script "clipboard-history"}"
        "SUPER,l,spawn_shell,${pkill} fuzzel || ${script "dmenu-logout"}"
        "SUPER,u,spawn_shell,${pkill} fuzzel || ${script "updater"}"
        "SUPER+SHIFT,w,spawn_shell,${pkill} fuzzel || ${script "change-wallpaper"}"
        "SUPER+SHIFT,e,spawn_shell,${pkill} fuzzel || ${script "bemoji"}"
        "SUPER+SHIFT,s,spawn,${script "screenshot"}"
        "SUPER,s,spawn,${script "toggle-wlsunset"}"
        "SUPER+SHIFT,b,spawn,${systemctl} --user restart waybar.service"

        "NONE,XF86Calculator,spawn,${qalculate}"
        "NONE,caps_lock,spawn,${script "caps-lock"}"
      ]
      ++ map (n: "CTRL+ALT,F${n},chvt,${n}") vts;

      bindl = [
        "NONE,XF86AudioRaiseVolume,spawn,${script "change-volume"} up"
        "NONE,XF86AudioLowerVolume,spawn,${script "change-volume"} down"
        "NONE,XF86AudioMute,spawn,${script "change-volume"} mute"
        "NONE,XF86AudioMicMute,spawn,${script "mute-mic"}"
        "NONE,XF86MonBrightnessUp,spawn,${script "change-brightness"} up"
        "NONE,XF86MonBrightnessDown,spawn,${script "change-brightness"} down"
        "NONE,XF86AudioPlay,spawn,${playerctl} play-pause"
        "NONE,XF86AudioNext,spawn,${playerctl} next"
        "NONE,XF86AudioPrev,spawn,${playerctl} previous"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_middle,togglefloating"
        "SUPER+CTRL,btn_left,moveresize,curresize"
      ];

      switchbind = [
        "fold,spawn,${wlr-randr} --output eDP-1 --off"
        "unfold,spawn,${wlr-randr} --output eDP-1 --on"
      ];

      # Written by matugen; optional so the build-time check doesn't need it
      source_optional = "~/.config/mango/colors.conf";
    };

    bottomPrefixes = [ "source" ];
  };
}
