# Installation is done of Macbook Pro M1 with Apple Silicon

**Installation of Nix CLI.**
Installation was done using https://nix.dev/manual/nix/2.18/installation/installing-binary#multi-user-installation. This resulted in installation using x86_64-darwin instead of aarch64-darwin.

Installed correctly using: [https://github.com/LnL7/nix-darwin/issues/843](https://github.com/LnL7/nix-darwin/issues/843) which instructs to install Nix using [https://github.com/DeterminateSystems/nix-installer#usage](https://github.com/DeterminateSystems/nix-installer#usage) . 

**Installation of Nix-darwin** 
Installation done using official instructions with flakes: https://github.com/LnL7/nix-darwin?tab=readme-ov-file#flakes

```sh
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
``` 
resulted in the following error:
*error: unable to download 'https://cache.nixos.org/visih4mxsxih75vfk0sz9b894dy78cys.narinfo': Problem with the SSL CA cert (path? access rights?) (77)*

I tried the following fix: https://github.com/NixOS/nix/issues/3261#issuecomment-721466043 but this resulted in `ln: /etc/ssl/certs/ca-certificates.crt: File exists` 

Another proposed solution was: https://github.com/NixOS/nix/issues/3261#issuecomment-1280014670. This resulted in the following:
```sh
> nix run nix-darwin -- switch --flake ~/.config/nix-darwin                                          
warning: creating lock file '/Users/silaspihl/.config/nix-darwin/flake.lock': 
• Added input 'nix-darwin':
    'github:LnL7/nix-darwin/a60ac02f9466f85f092e576fd8364dfc4406b5a6?narHash=sha256-I9Qd0LnAsEGHtKE9%2BuVR0iDFmsijWSy7GT0g3jihG4Q%3D' (2024-10-14)
• Added input 'nix-darwin/nixpkgs':
    follows 'nixpkgs'
• Added input 'nixpkgs':
    'github:NixOS/nixpkgs/7881fbfd2e3ed1dfa315fca889b2cfd94be39337?narHash=sha256-GBJRnbFLDg0y7ridWJHAP4Nn7oss50/VNgqoXaf/RVk%3D' (2024-10-15)
building the system configuration...
error: Unexpected files in /etc, aborting activation
The following files have unrecognized content and would be overwritten:

  /etc/ssl/certs/ca-certificates.crt
  /etc/nix/nix.conf

Please check there is nothing critical in these files, rename them by adding .before-nix-darwin to the end, and then try again.
```

Trying the following solution from Nix page: https://discourse.nixos.org/t/ssl-ca-cert-error-on-macos/31171/5. Received the error:
```sh
> nix run nix-darwin -- switch --flake ~/.config/nix-darwin                                              
building the system configuration...
error: Unexpected files in /etc, aborting activation
The following files have unrecognized content and would be overwritten:

  /etc/nix/nix.conf

Please check there is nothing critical in these files, rename them by adding .before-nix-darwin to the end, and then try again.
```

Ran command:
`sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin`

```sh
> nix run nix-darwin -- switch --flake ~/.config/nix-darwin    
error: experimental Nix feature 'nix-command' is disabled; add '--extra-experimental-features nix-command' to enable it
```

Ran the following command:
```sh
> nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake ~/.config/nix-darwin

building the system configuration...
user defaults...
setting up user launchd services...
setting up /Applications/Nix Apps...
setting up pam...
applying patches...
setting up /etc...
ln: failed to create symbolic link '/etc/ssl/certs/ca-certificates.crt': File exists
```

Removed the certificate even it was created before:
` sudo rm /etc/ssl/certs/ca-certificates.crt  `

Then ran the final command:
```sh
> nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake ~/.config/nix-darwin

building the system configuration...
user defaults...
setting up user launchd services...
setting up /Applications/Nix Apps...
setting up pam...
applying patches...
setting up /etc...
system defaults...
setting up launchd services...
reloading service org.nixos.activate-system
reloading service org.nixos.nix-daemon
reloading nix-daemon...
waiting for nix-daemon
waiting for nix-daemon
configuring networking...
setting up /Library/Fonts/Nix Fonts...
setting nvram variables...
```

Seems to be working. Ran the next command provided by the nix-darwin documentation:

```sh
> darwin-rebuild switch --flake ~/.config/nix-darwin
building the system configuration...
user defaults...
setting up user launchd services...
setting up /Applications/Nix Apps...
setting up pam...
applying patches...
setting up /etc...
system defaults...
setting up launchd services...
reloading nix-daemon...
waiting for nix-daemon
configuring networking...
setting up /Library/Fonts/Nix Fonts...
setting nvram variables...
```

Now I can build my flake.nix and run

`darwin-rebuild switch --flake ~/.config/nix-darwin`


**TL:DR**

*Install Nix*
`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`

*Creating flake from scratch*
```sh
cd ~/dotfiles
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

*Move file if exists*
`sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin`

*Remove certificates*
`sudo rm /etc/ssl/certs/ca-certificates.crt`

*Build nix-darwin*
`nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake ~/.config/nix-darwin`

*Build config using flake*
`darwin-rebuild switch --flake ~/.config/nix-darwin`
