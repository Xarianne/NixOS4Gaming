# /etc/nixos/modules/gaming/emulation.nix
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    retroarch
    retroarch-assets
    retroarch-joypad-autoconfig
  ];
}
