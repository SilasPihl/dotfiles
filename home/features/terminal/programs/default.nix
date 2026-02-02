{
  imports = [
    #./aichat.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./k9s.nix
    ./git.nix
    # ./git-cliff.nix # Include once AI automated flow for new commits is introduced
    ./lazygit.nix
    #./nix-index.nix
    ./ripgrep.nix
    ./sesh.nix
    # ./tailspin.nix # https://github.com/bensadeh/tailspin/issues/177#issue-2631369690
    #./tealdeer.nix
    ./tmux.nix
    ./yazi.nix
    #./zathura.nix
    ./zoxide.nix
  ];

  programs = {
    fastfetch.enable = true;
    jq.enable = true;
  };
}