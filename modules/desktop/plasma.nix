# /etc/nixos/modules/desktop/plasma.nix
{ pkgs, ... }:
{
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # KDE Applications
  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
  ];
}
