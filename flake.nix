{
  description = "Sebastian NixOS and Home-Manager flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs?ref=nixos-24.11"; };
    nixpkgs-unstable = { url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable"; };
    # https://github.com/catppuccin/nix/issues/162
    catppuccin.url = "github:catppuccin/nix";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim
    , nix-index-database, catppuccin }@inputs:
    let user = "sebastianballe";
    in {

      homeConfigurations = {

        mac = # home-manager switch --flake .#mac
          let
            system = "aarch64-darwin";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};

            modules = [
              { nixpkgs.config.allowUnfree = true; }
              nix-index-database.hmModules.nix-index
              # https://github.com/catppuccin/nix/issues/162
              # catppuccin.nixosModules.catppuccin
              ./home/${user}.nix
            ];
          };

        # Not up-to-date
        devos = # home-manager switch --flake .#devos
          let
            system = "aarch64-linux";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              ./home-manager/${user}.nix
              ./home-manager/programs/chromium.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
            ];
          };

      };

      nixosConfigurations = {

        # Not up-to-date
        devos = # sudo nixos-rebuild switch --flake .#devos --impure
          let system = "aarch64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "24.11";
              }

              ./hosts/devos/configuration.nix
              ./users/${user}.nix
              ./hosts/docker.nix
              ./hosts/fonts.nix
              ./hosts/gnome.nix
              ./hosts/logind.nix
              ./pkgs/1password.nix
            ];
          };

      };
    };
}
