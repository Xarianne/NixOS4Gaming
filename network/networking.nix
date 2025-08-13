# /etc/nixos/modules/network/networking.nix
{ systemHostname, ... }:
{
  networking = {
    hostName = systemHostname;
    networkmanager.enable = true;

    # Wireless support (disabled by default)
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant

    # Network proxy configuration
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Firewall configuration
    firewall = {
      enable = true;  # Enabled by default in NixOS

      # Open ports in the firewall
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];

      # Or disable the firewall altogether (not recommended)
      # enable = false;
    };
  };

  # OpenSSH daemon
  # services.openssh.enable = true;
}
