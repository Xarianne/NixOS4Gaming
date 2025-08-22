# /etc/nixos/flake.nix

{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    #Lanzaboote for secure boot, delete if unwanted
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
      lanzaboote,  # delete if you don't want secure boot
      nix-flatpak,
      home-manager,
      chaotic,
      ...
    }@inputs:

    let
      # Define your username here at the flake level
      # This is the single place to change it for this system
      systemUsername = "testuser"; # <--- IMPORTANT: Change this line to your desired username

      # Define your hostname here at the flake level
      # This is the single place to change it for this system
      systemHostname = "testhost"; # <--- IMPORTANT: Change this line to your desired hostname
    in

    {
      nixosConfigurations.${systemHostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix

          # Secure boot files, delete if unwanted, otherwise uncomment
          # ./modules/security/secure-boot.nix
          # lanzaboote.nixosModules.lanzaboote

          # Declarative flaptak config
          nix-flatpak.nixosModules.nix-flatpak

          # Chaotic Nyx repo
          chaotic.nixosModules.default

          # Home Manager module
          home-manager.nixosModules.home-manager

          # Home Manager configuration
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit systemUsername systemHostname;
              };
              users.${systemUsername} = import ./home.nix;
            };
          }
        ];

        # Pass special arguments to your modules
        specialArgs = {
          inherit inputs systemUsername systemHostname;
        };
      };
    };
}
