{
  description = "Sebastian NixOS and Home-Manager flake";

  inputs = {

    nixpkgs = { url = "github:NixOS/nixpkgs?ref=nixos-24.05"; };

    nixpkgs-unstable = { url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim }@inputs:
    let user = "sebastianballe";
    in {

      nixosConfigurations = {

        devos = # sudo nixos-rebuild switch --flake .#devos --impure
          let system = "aarch64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "24.05";
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

      homeConfigurations = {
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

              ./home-manager/${user}.nix
              ./home-manager/programs/bat.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/kitty.nix
              ./home-manager/programs/nvim/default.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix

            ];
          };
      };

    };
}
