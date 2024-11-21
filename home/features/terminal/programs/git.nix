{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Sebastian Balle";
    userEmail = "s.balle@sbconsultancy.dk";

    aliases = { st = "status"; };

    includes = [
      {
        path = "~/.gitconfig-leo";
        condition = "gitdir:~/git/leopharma/";
      }
      {
        path = "~/.gitconfig-genmab";
        condition = "gitdir:~/git/genmab/";
      }
      {
        path = "~/.gitconfig-lix";
        condition = "gitdir:~/git/lix/";
      }
    ];

    delta = {
      enable = true;
      options = {
        navigate = true; # use n and N to move between diff sections
        # side-by-side = true;
        diff-so-fancy = true;
        line-numbers = true;
      };
    };
  };
}
