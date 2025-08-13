# /etc/nixos/home.nix
{
  config,
  pkgs,
  lib,
  systemUsername,
  systemHostname,
  ...
}:

{
  # Set your home.stateVersion. This is important for future Home Manager upgrades.
  # Use the current NixOS release version or a recent one.
  home.stateVersion = "25.11"; # Example: Use the same as your home-manager flake URL release

  home.username = systemUsername;
  home.homeDirectory = "/home/${systemUsername}";

  # Example: Add some packages
  home.packages = with pkgs; [
    kdePackages.kate
    davinci-resolve
    mangohud
    kdePackages.qtstyleplugin-kvantum
    goverlay
  ];

  # Example: Manage a dotfile (e.g., ~/.config/nvim/init.vim)
  # home.file.".config/nvim/init.vim".source = ./dotfiles/nvim/init.vim;

  # Add more configurations as needed, e.g., programs.neovim, programs.bash, services.gpg-agent, etc.
}
