{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Sebastian Balle";
    userEmail = "s.balle@sbconsultancy.dk";
    signing = {
      signByDefault = true;
      key = "22D898A0ECB0003C";
    };

    aliases = {
      st = "status";
      c = "commit --signoff --message";
    };

    includes = [
      {
        contents = {
          pull = {
            rebase = true;
          };
        };
      }
      {
        condition = "gitdir:~/git/leopharma/";
        contents = {
          user = {
            email = "qbedk@leo-pharma.com";
          };
          commit = {
            gpgSign = false;
          };
        };
      }
      {
        condition = "gitdir:~/git/genmab/";
        contents = {
          user = {
            email = "sbal@genmab.com";
            signingKey = "6631EEAFE1A5B9EA";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
      {
        condition = "gitdir:~/git/lix-one/";
        contents = {
          user = {
            email = "sbal@lix.one";
            signingKey = "9863FCDF91EC9482";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];

    delta = {
      enable = true;
      options = {
        navigate = true; # use n and N to move between diff sections
        diff-so-fancy = true;
        line-numbers = true;
      };
    };
  };

  programs.gpg = {
    enable = true;
  };
}