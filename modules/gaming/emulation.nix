# /etc/nixos/modules/gaming/emulation.nix
{ config, lib, pkgs, ... }:

{
  options = {
    gaming.emulation.enable = lib.mkEnableOption "retro gaming emulation support";
  };

  config = lib.mkIf config.gaming.emulation.enable {
    environment.systemPackages = with pkgs; [
      retroarch
      retroarch-assets
      retroarch-joypad-autoconfig
    ];
  };
}
