# etc/nixos/modules/hardware/peripherals.nix
{ pkgs, ... }:
{
  # Enable udevrules for OpenRGB
  services.hardware.openrgb.enable = true;

  # Allows to run programs that require FHS libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add the missing libraries here
  ];

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Peripheral tools and utilities
  environment.systemPackages = with pkgs; [
    
    python313Packages.openrazer

    # Wheel and Joystic testing and configuration tools
    jstest-gtk          # GUI for testing/calibrating joysticks
    linuxConsoleTools   # Includes jscal, jstest (command line tools
  ];

  # Optional: Add user to input group (should not be needed on modern NixOS)
  # users.users.youruser.extraGroups = [ "input" ];

  # Modern kernels should support force feedback and many joysticks 
  # on their own without the need for third party software
  # Some distros also add Xone, but kernels nowadays provide good 
  # controller support out of the box
}
