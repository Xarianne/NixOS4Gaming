# /etc/nixos/modules/gaming/gaming-optimizations.nix
{ config, pkgs, lib, ... }:
{
  # Use latest standard NixOS kernel, choose either this or the CachyOS one (below)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Use Cachy kernel (turned off by default)
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  
  # Enable ntsync - helps Windows games work properly on Linux by fixing
  # communication issues between different parts of the game
  boot.initrd.kernelModules = [ "ntsync" ];
  
  # Distributes hardware interrupts across CPU cores to reduce stuttering
  # services.irqbalance.enable = true;
  
  # Optional: Kernel parameters for additional performance
  # boot.kernelParams = [
  #   "mitigations=off"     # Security/performance trade-off (~5% gain)
  #   "amd_pstate=active"   # For Zen 2+ CPUs
  # ];
  
  # Optional: CPU governor for maximum performance
  # powerManagement.cpuFreqGovernor = "performance";
}
