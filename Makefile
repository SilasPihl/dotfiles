.DEFAULT_GOAL := home

FLAKE_DIR=./nix-darwin
HOME_MANAGER_PATH="/nix/store/4ivg0skbbk1ng205xxmh1d9zg5zpj6yy-home-manager-0-unstable-2024-09-26/bin/home-manager"
HOME_MANAGER_DIR=./home-manager

system:
	@echo "Applying system-wide updates"
	darwin-rebuild switch --flake $(FLAKE_DIR) --impure

.PHONY: home
home:
	@echo "Applying home-manager configuration..."
	$(HOME_MANAGER_PATH) switch -f $(HOME_MANAGER_DIR)/home.nix

.PHONY: clean
clean:
	@echo "Cleaning the Nix store (optional)..."
	nix-collect-garbage -d
