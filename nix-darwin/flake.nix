{
  description = "Sebastian's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # Enable Zsh shell

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;  # Adjust based on your Nix-darwin system version
      nixpkgs.hostPlatform = "aarch64-darwin";  # Use this for Apple Silicon, x86_64-darwin for Intel

      # Homebrew installations
      homebrew.enable = true;
      homebrew.casks = [
        "basictex"
        "docker"
        "font-meslo-lg-nerd-font"
        "git-credential-manager"
        "git-credential-manager-core"
        "raycast"
        "slack"
        "vmware-fusion"
      ];
      homebrew.brews = [
        "imagemagick"
      ];
    };
  in
  {
    darwinConfigurations."Sebastians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # Adjust based on your architecture
      modules = [
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sebastianballe = import ./home.nix;
        }
      ];
    };
  };
}
