# /etc/nixos/modules/network/dns.nix
{ lib, ... }:
{
  # Custom DNS using Control D's malware-blocking DNS
  # To use different DNS providers, replace the DNS line:
  # - Quad9: DNS=9.9.9.9#dns.quad9.net
  # - Cloudflare: DNS=1.1.1.1#cloudflare-dns.com
  # - Mullvad: DNS=194.242.2.2#dns.mullvad.net

  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=p1.freedns.controld.com
      DNSOverTLS=yes
    '';
  };

  networking.networkmanager = {
    dns = lib.mkForce "systemd-resolved";
    settings = {
      main.rc-manager = "unmanaged";
      dhcp.use-dns = false;
    };
  };
}
