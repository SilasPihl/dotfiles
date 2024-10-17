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
      programs.zsh.enable = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;  # Adjust based on your Nix-darwin system version
      nixpkgs.hostPlatform = "aarch64-darwin";  # Apple Silicon architecture

      homebrew.enable = true;
      homebrew.casks = [
        # "basictex"
        # "docker"
        # "font-meslo-lg-nerd-font"
        # "git-credential-manager"
        # "raycast"
        # "slack"
        # "vmware-fusion"
      ];
    };
  in
  {
    darwinConfigurations."Sebastians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";  # Explicitly for Apple Silicon
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
