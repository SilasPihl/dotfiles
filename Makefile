.DEFAULT_GOAL := home

FLAKE_DIR=./nix-darwin
HOME_MANAGER_DIR=./home-manager

system:
	@echo "Applying system-wide updates"
	darwin-rebuild switch --flake $(FLAKE_DIR) --impure

.PHONY: home
home:
	@echo "Applying home-manager configuration..."
	home-manager switch -f $(HOME_MANAGER_DIR)/home.nix

.PHONY: clean
clean:
	@echo "Cleaning the Nix store (optional)..."
	nix-collect-garbage -d
