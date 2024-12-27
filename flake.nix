{
  description = "Sebastian NixOS and Home-Manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      nix-index-database,
    }@inputs:
    let
      user = "sebastianballe";
    in
    {

      homeConfigurations = {

        mac = # home-manager switch --flake .#mac
          let
            system = "aarch64-darwin";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in
          home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit
                inputs
                system
                user
                pkgs-stable
                ;
            };
            pkgs = nixpkgs-unstable.legacyPackages.${system};

            modules = [
              { nixpkgs.config.allowUnfree = true; }
              nix-index-database.hmModules.nix-index
              ./home/${user}.nix
            ];
          };

      };

    };
}