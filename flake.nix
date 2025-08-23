# /etc/nixos/flake.nix

{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Lanzaboote for secure boot, uncomment the 4 lines below if wanted, otherwise delete
    # lanzaboote = {
      # url = "github:nix-community/lanzaboote/v0.4.2";  # <--- This version might change, check https://github.com/nix-community/lanzaboote for the latest version
      # inputs.nixpkgs.follows = "nixpkgs";
    # };

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
      # lanzaboote,  # uncomment if wanted, otherwise delete
      nix-flatpak,
      home-manager,
      chaotic,
      ...
    }@inputs:

    let
      # Define your username here at the flake level
      # This is the single place to change it for this system
      systemUsername = "your-username"; # <--- IMPORTANT: Change this line to your desired username

      # Define your hostname here at the flake level
      # This is the single place to change it for this system
      systemHostname = "your-hostname"; # <--- IMPORTANT: Change this line to your desired hostname
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
