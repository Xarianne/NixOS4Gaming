# /etc/nixos/modules/hardware/amd-graphics.nix
{ config, pkgs, lib, ... }:
{
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # chaotic.mesa-git.enable = true;  # <----- uncomment this line if you want mesa-git
  
  # Graphics configuration for AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Add ROCm compute libraries for DaVinci Resolve
      rocmPackages.clr.icd
    ];
  };
}
