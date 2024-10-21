{
  description = "Sebastian aarch64-darwin system flake with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    configuration = { pkgs, ... }:
      let
        userPackages = with pkgs; [
          bat
          direnv
          docker
          docker-credential-helpers
          eza
          fzf
          gitFull
          kitty
          lazydocker
          lazygit
          markdownlint-cli
          neovim
          obsidian
          raycast
          slack
          tmux
          vim
          zoxide
        ];
      in {
        environment.systemPackages = userPackages;

        homebrew = {
          enable = true;

          casks = [
            "1password"
          ];
        };

        services.nix-daemon.enable = true;

        nix.settings.experimental-features = "nix-command flakes";

        nixpkgs.hostPlatform = "aarch64-darwin";
        nixpkgs.config.allowUnfree = true;

        programs.zsh.enable = true;

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;

        users.users.sebastianballe.home = "/Users/sebastianballe";

        home-manager.backupFileExtension = "backup";

        security.pam.enableSudoTouchIdAuth = true;
      };
  in {
    darwinConfigurations."Sebastians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sebastianballe = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."Sebastians-MacBook-Pro".pkgs;
  };
}
