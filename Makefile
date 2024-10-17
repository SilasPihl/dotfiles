# Makefile for managing system configuration using Nix flakes

# Path to the nix-darwin flake in the dotfiles repo
FLAKE_DIR = ./nix-darwin
FLAKE_SYSTEM = $(FLAKE_DIR)#Sebastians-MacBook-Pro

# Default target: update both system and home-manager
.PHONY: all
all: system-update home-manager-switch

# Target to update the system using nix-darwin
.PHONY: system-update
system-update:
	@echo "Updating system configuration using nix-darwin..."
	nix run nix-darwin --impure -- switch --flake $(FLAKE_DIR) --show-trace
# Target to switch home-manager configuration
.PHONY: home-manager-switch
home-manager-switch:
	@echo "Applying home-manager configuration..."
	home-manager switch --flake $(FLAKE_DIR)

# Clean target for clearing the Nix store (optional)
.PHONY: clean
clean:
	@echo "Cleaning the Nix store (optional)..."
	nix-collect-garbage -d
