# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{
  config,
  pkgs,
  lib,
  systemUsername,
  systemHostname,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix   # This is not included, use the one you generated during install

    # System modules
    ./modules/system/localization.nix
    ./modules/system/maintenance.nix

    # Gaming
    ./modules/gaming/gaming-optimizations.nix
    ./modules/gaming/gaming-packages.nix

    # Desktop and audio
    ./modules/desktop/plasma.nix
    ./modules/audio/pipewire.nix

    # Hardware
    ./modules/hardware/automount.nix
    ./modules/hardware/peripherals.nix
    ./modules/hardware/amd-graphics.nix

    # Features
    ./modules/flatpak/flatpaks.nix
    ./modules/virtualisation/virtualisation.nix

    # Network
    ./modules/network/networking.nix
  ];

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${systemUsername} = {
    isNormalUser = true;
    description = "${systemUsername}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
