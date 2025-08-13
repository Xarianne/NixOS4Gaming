# /etc/nixos/modules/disks/automount.nix
{ config, pkgs, ... }:

{
  # Enable automounting for removable and internal drives
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Allow wheel users to mount without password
  environment.etc."polkit-1/rules.d/90-local-mount.rules".text = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';
}
