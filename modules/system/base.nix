{ config, ... }:
let
  inherit (config) username flakeDir;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
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
      };

      programs.nh = {
        enable = true;
        flake = flakeDir;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 14d --keep 5";
        };
      };

      programs.git.enable = true;

      time.timeZone = "Europe/Madrid";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "es";

      security.doas = {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            persist = true;
          }
        ];
      };
      security.sudo.enable = false;

      users.users.${username} = {
        isNormalUser = true;
        description = "Daniel Calonge";
        shell = pkgs.bashInteractive;
        extraGroups = [
          "wheel"
          "video"
          "input"
        ];
      };

      services.getty = {
        loginOptions = "-- ${username}";
        extraArgs = [
          "--skip-login"
          "--noreset"
        ];
      };

      environment.binsh = "${pkgs.dash}/bin/dash";
    };

  flake.modules.homeManager.base = {
    home.stateVersion = "26.05";

    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
