# /etc/nixos/flake.nix

{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    #Lanzaboote for secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative flaptak config
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    #Chaotic Nyx repo
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Home Manager unstable branch
    home-manager = {
      url = "github:nix-community/home-manager/master"; # <-- This is the unstable branch
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      nix-flatpak,
      home-manager,
      chaotic,
      ...
    }@inputs:

    let
      # Define your username here at the flake level
      # This is the single place to change it for this system
      systemUsername = "username"; # <--- IMPORTANT: Change this line to your desired username

      # Define your hostname here at the flake level
      # This is the single place to change it for this system
      systemHostname = "hostname"; # <--- IMPORTANT: Change this line to your desired hostname
    in

    {
      nixosConfigurations.${systemHostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix

          # Secure boot files
          # ./modules/security/secure-boot.nix  <--- Turned off Lanzaboote for the first build as it can cause issues, turn back on after successful build if you want secure boot 
          # lanzaboote.nixosModules.lanzaboote  <--- Turned off Lanzaboote for the first build as it can cause issues, turn back on after successful build if you want secure boot

          # Declarative flaptak config
          nix-flatpak.nixosModules.nix-flatpak

          # Chaotic Nyx repo
          chaotic.nixosModules.default

          # Home Manager module
          home-manager.nixosModules.home-manager
        ];

        # Pass special arguments to your modules
        specialArgs = {
          inherit inputs systemUsername systemHostname;
        };
      };
    };
}
