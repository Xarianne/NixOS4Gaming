# /etc/nixos/modules/virtualisation/virtualisation.nix
{ pkgs, systemUsername, ... }:
{
  # Enable virt-manager and virtualization
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  # Add your user to the 'libvirtd' group
  users.users.${systemUsername}.extraGroups = [ "libvirtd" ];

  # Fix VM networking - these are standard requirements for libvirt NAT
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;   # 1. Enable IP forwarding (required for NAT)
  networking.firewall.trustedInterfaces = [ "virbr0" ];  # 2. Tell firewall to trust the libvirt bridge
}
