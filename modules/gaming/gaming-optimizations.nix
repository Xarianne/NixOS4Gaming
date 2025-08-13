# /etc/nixos/modules/gaming/gaming-optimizations.nix
{ config, pkgs, lib, ... }:

{
  # Use latest standard NixOS kernel, choose either this or the CachyOS one (below)
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use Cachy kernel (turned on by default)
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Enable ntsync - helps Windows games work properly on Linux by fixing
  # communication issues between different parts of the game
  boot.initrd.kernelModules = [ "ntsync" ];

  # Mesa-git drivers - bleeding edge graphics drivers for AMD
  # Provides performance improvements for newer AMD GPUs (especially RDNA 3/4)
  chaotic.mesa-git.enable = true;

  # Distributes hardware interrupts across CPU cores to reduce stuttering - no difference in performance on my setup, no harm keeping it here if I ever want to activate it
  # services.irqbalance.enable = true;

  # Steam and gaming platform support
  programs.steam = {
    enable = true;
    # Uncomment for dedicated GameScope session from login screen:
    # gamescopeSession.enable = true;
  };

  # Graphics configuration for AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    gamescope  # Valve's micro-compositor for gaming
    mangohud   # Performance overlay
    goverlay   # GUI for MangoHud configuration
    lutris     # Another game launcher
  ];

  # Optional: Kernel parameters for additional performance
  # boot.kernelParams = [
  #   "mitigations=off"     # Security/performance trade-off (~5% gain)
  #   "amd_pstate=active"   # For Zen 2+ CPUs
  # ];

  # Optional: CPU governor for maximum performance
  # powerManagement.cpuFreqGovernor = "performance";
}
