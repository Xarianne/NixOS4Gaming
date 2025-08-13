# /etc/nixos/modules/flatpak-packages.nix
{ config, pkgs, ... }:

# Enable Flatpak support
services.flatpak.enable = true;

# Declaratively manage Flatpak packages
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
    "io.github.radiolamp.mangojuice"

  ];
}
