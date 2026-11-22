{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      documentation.nixos.enable = false;

      environment.systemPackages = with pkgs; [
        wget
        curl
        unzip
        zip
        file
        man-pages
        vulkan-tools
      ];
    };
}
