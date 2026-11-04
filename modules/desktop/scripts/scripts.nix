{ config, ... }:
let
  inherit (config) flakeDir;

  overlay =
    final: _prev:
    let
      scriptExcluding =
        excludeShellChecks: name: runtimeInputs:
        final.writeShellApplication {
          inherit name runtimeInputs excludeShellChecks;
          text = builtins.replaceStrings [ "@flakeDir@" ] [ flakeDir ] (builtins.readFile ./${name}.sh);
          bashOptions = [ ];
        };
      script = scriptExcluding [ ];
    in
    {
      dotfiles-scripts = with final; {
        bemoji = script "bemoji" [
          curl
          jq
          wl-clipboard
          libnotify
          fuzzel
          gnused
          coreutils
        ];
        caps-lock = script "caps-lock" [
          libnotify
          gnugrep
          coreutils
        ];
        change-brightness = script "change-brightness" [
          brightnessctl
          libnotify
        ];
        change-volume = script "change-volume" [
          wireplumber
          libnotify
          gawk
        ];
        change-wallpaper = scriptExcluding [ "SC2059" ] "change-wallpaper" [
          fuzzel
          matugen
          curl
          jq
          file
          findutils
          coreutils
          foot
          yazi
          systemd
        ];
        clipboard-history = script "clipboard-history" [
          cliphist
          fuzzel
          wl-clipboard
        ];
        dmenu-bluetooth = script "dmenu-bluetooth" [
          bluez
          util-linux
          procps
          fuzzel
          gnugrep
          coreutils
        ];
        dmenu-logout = script "dmenu-logout" [
          fuzzel
          systemd
        ];
        keyboard-backlight = script "keyboard-backlight" [
          brightnessctl
          libnotify
          coreutils
        ];
        kb-layout = script "kb-layout" [
          mango
          jq
          libnotify
          coreutils
        ];
        mute-mic = script "mute-mic" [
          wireplumber
          libnotify
          gnugrep
        ];
        screenshot = script "screenshot" [
          grim
          slurp
          wl-clipboard
          libnotify
          coreutils
        ];
        toggle-wlsunset = script "toggle-wlsunset" [ systemd ];
        updater = scriptExcluding [ "SC2059" "SC2016" ] "updater" [
          fuzzel
          foot
          git
          nh
        ];
        waybar-updates = script "waybar-updates" [
          git
          jq
          coreutils
        ];
        waybar-weather = scriptExcluding [ "SC2086" ] "waybar-weather" [
          curl
          jq
          coreutils
        ];
        wlr-menu = script "wlr-menu" [
          wlr-randr
          jq
          fuzzel
          brightnessctl
          gnused
        ];
      };
    };
in
{
  flake.modules.nixos.desktop = {
    nixpkgs.overlays = [ overlay ];
  };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues pkgs.dotfiles-scripts;
    };
}
