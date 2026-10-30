{ inputs, vars }:
final: _prev:
let
  script =
    name: runtimeInputs:
    {
      excludeShellChecks ? [ ],
    }:
    final.writeShellApplication {
      inherit name runtimeInputs excludeShellChecks;
      text = builtins.replaceStrings [ "@flakeDir@" ] [ vars.flakeDir ] (
        builtins.readFile ./scripts/${name}.sh
      );
      # Plain sh semantics, like the original scripts
      bashOptions = [ ];
    };
in
with final;
{
  helium = symlinkJoin {
    name = "helium";
    paths = [ inputs.helium.packages.${final.stdenv.hostPlatform.system}.default ];
    nativeBuildInputs = [ makeWrapper ];
    # Chromium only honours the last --enable-features, so the upstream
    # WaylandWindowDecorations is repeated here.
    postBuild = ''
      wrapProgram $out/bin/helium \
        --add-flags "--enable-features=AcceleratedVideoEncoder,VaapiVideoDecoder,AcceleratedVideoDecodeLinuxGL,TouchpadOverscrollHistoryNavigation,FluentOverlayScrollbar,WaylandWindowDecorations" \
        --add-flags "--ozone-platform-hint=wayland" \
        --add-flags "--password-store=basic"
    '';
    meta.mainProgram = "helium";
  };

  dotfiles-scripts = {
    bemoji = script "bemoji" [
      curl
      jq
      wl-clipboard
      libnotify
      fuzzel
      gnused
      coreutils
    ] { };
    caps-lock = script "caps-lock" [
      libnotify
      gnugrep
      coreutils
    ] { };
    change-brightness = script "change-brightness" [
      brightnessctl
      libnotify
    ] { };
    change-volume = script "change-volume" [
      wireplumber
      libnotify
      gawk
    ] { };
    change-wallpaper = script "change-wallpaper" [
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
    ] { excludeShellChecks = [ "SC2059" ]; };
    clipboard-history = script "clipboard-history" [
      cliphist
      fuzzel
      wl-clipboard
    ] { };
    dmenu-bluetooth = script "dmenu-bluetooth" [
      bluez
      util-linux
      procps
      fuzzel
      gnugrep
      coreutils
    ] { };
    dmenu-logout = script "dmenu-logout" [
      fuzzel
      systemd
    ] { };
    keyboard-backlight = script "keyboard-backlight" [
      brightnessctl
      libnotify
      coreutils
    ] { };
    mute-mic = script "mute-mic" [
      wireplumber
      libnotify
      gnugrep
    ] { };
    screenshot = script "screenshot" [
      grim
      slurp
      wl-clipboard
      libnotify
      coreutils
    ] { };
    toggle-wlsunset = script "toggle-wlsunset" [ systemd ] { };
    updater =
      script "updater"
        [
          fuzzel
          foot
          nh
        ]
        {
          excludeShellChecks = [
            "SC2059"
            "SC2016"
          ];
        };
    waybar-updates = script "waybar-updates" [
      curl
      jq
      gnused
      gnugrep
      coreutils
    ] { };
    waybar-weather = script "waybar-weather" [
      curl
      jq
      coreutils
    ] { excludeShellChecks = [ "SC2086" ]; };
    wlr-menu = script "wlr-menu" [
      wlr-randr
      jq
      fuzzel
      brightnessctl
      gnused
    ] { };
  };
}
