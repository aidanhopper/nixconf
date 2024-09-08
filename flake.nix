{
  description = "A very basic flake";



  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = { nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations = {

        default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/default/configuration.nix 
            inputs.home-manager.nixosModules.default
          ];
        };

	
        surface = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/surface/configuration.nix 
            inputs.home-manager.nixosModules.default
            inputs.nixos-hardware.microsoft-surface-pro-intel
          ];
        };
	
      };

      homeManagerModules.default = ./homeManagerModules;

    };
}
