{ config, lib, ... }:
{
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Name of the user account on every host.";
    };
    flakeDir = lib.mkOption {
      type = lib.types.str;
      description = "Where this repo is cloned on every host.";
    };
  };

  config = {
    username = "daniel";
    flakeDir = "/home/${config.username}/nixos-dotfiles";
  };
}
