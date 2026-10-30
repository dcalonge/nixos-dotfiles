{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    substituters = [ "https://cache.nixos.org" ];
    builders-use-substitutes = true;
  };

  programs.nh = {
    enable = true;
    flake = vars.flakeDir;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep 5";
    };
  };

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "es";

  users.users.${vars.user} = {
    isNormalUser = true;
    description = "Daniel Calonge";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
  };

  # Password-only login
  services.getty = {
    loginOptions = "-- ${vars.user}";
    extraArgs = [
      "--skip-login"
      "--noreset"
    ];
  };

  environment.binsh = "${pkgs.dash}/bin/dash";

  networking = {
    hostName = vars.host;
    useNetworkd = true;
    useDHCP = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = false;
    };
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-wired" = {
        matchConfig.Name = "en*";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        dhcpV4Config.RouteMetric = 100;
        ipv6AcceptRAConfig.RouteMetric = "100:100:100";
      };
      "20-wifi" = {
        matchConfig.Name = "wl*";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        dhcpV4Config.RouteMetric = 600;
        ipv6AcceptRAConfig.RouteMetric = "600:600:600";
      };
    };
    wait-online.anyInterface = true;
  };

  services.resolved.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.libvdpau-va-gl ];
  };

  environment.sessionVariables = {
    VDPAU_DRIVER = "va_gl";
    NIXOS_OZONE_WL = "1";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.acpid.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;
  services.udisks2.enable = true;

  # programs.xwayland stays off: its package has to be compiled locally
  programs.mango.enable = true;
  services.graphical-desktop.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.mango = lib.mkForce {
      default = [
        "gtk"
        "wlr"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  programs.gtklock = {
    enable = true;
    config.main.style = "${config.users.users.${vars.user}.home}/.config/gtklock/style.css";
  };

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.git.enable = true;
  security.polkit.enable = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [ "com.stremio.Stremio" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    unzip
    zip
    file
    man-pages
    libva-utils
    vulkan-tools
  ];
}
