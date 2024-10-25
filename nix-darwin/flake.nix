{
  description = "Sebastian aarch64-darwin system flake";

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
          docker
          docker-credential-helpers
          gitFull
          kitty
          lazydocker
          lazygit
          markdownlint-cli
          neovim
          obsidian
          raycast
          slack
          skhd
          spotify
          spicetify-cli
          tree
          tmux
          vim
          vivid
          yabai
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

        security.pam.enableSudoTouchIdAuth = true;
      };
  in {
    darwinConfigurations."Sebastians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
      ];
    };

    darwinPackages = self.darwinConfigurations."Sebastians-MacBook-Pro".pkgs;
  };
}
