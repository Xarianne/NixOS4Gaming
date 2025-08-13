{ pkgs, ... }:
{
  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System packages for maintenance
  environment.systemPackages = with pkgs; [
    git
    git-filter-repo
    yadm
    fwupd
  ];

  # Enable updating of Secure Boot keys
  services.fwupd.enable = true;
}
