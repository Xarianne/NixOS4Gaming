# /etc/nixos/modules/hardware/amd-graphics.nix
{ config, pkgs, lib, ... }:
{
  # Mesa-git drivers - bleeding edge graphics drivers for AMD
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
  
  # Enable ROCm for compute workloads
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  
  # Make sure your user can access the GPU for compute
  users.groups.render = {};
  users.users.${config.users.users.keys.systemUsername or "your-username"}.extraGroups = [ "render" "video" ];
}
