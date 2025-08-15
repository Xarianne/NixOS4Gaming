# /etc/nixos/modules/flatpaks.nix
{ config, pkgs, ... }:

{
  # Enable Flatpak support
  services.flatpak.enable = true;

  # Declaratively manage Flatpak packages
  services.flatpak.packages = [
    { appId = "com.obsproject.Studio"; origin = "flathub"; }
    "com.obsproject.Studio.Plugin.InputOverlay" # OBS addon
    "com.obsproject.Studio.Plugin.BackgroundRemoval" # OBS addon
    "org.freedesktop.Platform.VulkanLayer.OBSVkCapture" OBS addon
    "com.vivaldi.Vivaldi"
    "com.discordapp.Discord"
    "org.localsend.localsend_app"
    "com.github.tchx84.Flatseal"
    "io.github.flattool.Warehouse"
    "com.vysp3r.ProtonPlus"
    "io.podman_desktop.PodmanDesktop"
    "io.github.radiolamp.mangojuice"
    "org.fedoraproject.MediaWriter"

  ];
}
