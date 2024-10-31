.DEFAULT_GOAL := mac

.PHONY: mac
mac:
	@echo "Applying home-manager configuration..."
	home-manager switch --flake .#mac --impure

.PHONY: mac-install
mac-install:
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager; \
	nix-channel --update; \
	nix-shell '<home-manager>' -A install; \

.PHONY: clean
clean:
	@echo "Cleaning the Nix store (optional)..."
	nix-collect-garbage -d
