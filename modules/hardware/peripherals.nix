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

  # Secure boot tools if using lanzaboote
  environment.systemPackages = with pkgs; [
    python313Packages.openrazer
  ];
}
