{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
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
    };
}
