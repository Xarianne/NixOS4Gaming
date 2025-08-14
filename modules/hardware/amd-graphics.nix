# /etc/nixos/modules/hardware/amd-graphics.nix
{ config, pkgs, lib, ... }:
{
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # Provides performance improvements for newer AMD GPUs (especially RDNA 3/4)
  chaotic.mesa-git.enable = true;
  
  # Graphics configuration for AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Add ROCm compute libraries for DaVinci Resolve
      rocmPackages.clr.icd
      rocmPackages.rocm-runtime
      rocmPackages.rocblas
      rocmPackages.rocsparse
      rocmPackages.rocsolver
      rocmPackages.rocfft
      rocmPackages.miopen
    ];
  };
}
