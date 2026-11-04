{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
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
    };
}
