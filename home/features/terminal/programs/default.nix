{
  imports = [
    ./aichat.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./nix-index.nix
    ./ripgrep.nix
    # ./tailspin.nix # https://github.com/bensadeh/tailspin/issues/177#issue-2631369690
    ./tealdeer.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  programs = {
    fastfetch.enable = true;
    jq.enable = true;
  };
}
