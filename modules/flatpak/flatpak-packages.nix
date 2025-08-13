# /etc/nixos/modules/flatpak-packages.nix
{ config, pkgs, ... }:

{
  services.flatpak.packages = [
    {
      appId = "com.obsproject.Studio";
      origin = "flathub";
    }
    "com.obsproject.Studio.Plugin.InputOverlay" # OBS addon
    "com.obsproject.Studio.Plugin.BackgroundRemoval" # OBS addon
    "com.github.tchx84.Flatseal"
    "io.github.flattool.Warehouse"
    "com.vysp3r.ProtonPlus"
    "net.lutris.Lutris"
    "io.github.radiolamp.mangojuice"

  ];
}
