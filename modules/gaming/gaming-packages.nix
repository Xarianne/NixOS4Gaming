# /etc/nixos/modules/gaming/gaming-packages.nix
{ config, pkgs, lib, ... }:
{
  # Steam and gaming platform support
  programs.steam = {
    enable = true;
  };
  
  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    gamescope      # Valve's micro-compositor for gaming
    mangohud       # Performance overlay
    goverlay       # GUI for MangoHud configuration
    lutris         # Another game launcher
    input-remapper # Universal input device remapping
  ];
}
