{ pkgs, ... }: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "23E6EAD9D5C1D853";
    };
    settings = {
      user = {
        name = "Silas Pihl";
        email = "silaspihl@gmail.com";
      };
      alias = {
        st = "status";
        c = "commit --signoff --message";
        p = "push";
      };
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
        condition = "gitdir:~/repos/lix/";
        contents = {
          user = {
            email = "silas@lix.one";
            signingKey = "F0CDD8E0DAE1C768";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true; # use n and N to move between diff sections
      diff-so-fancy = true;
      line-numbers = true;
    };
  };

  programs.gpg = {
    enable = true;
  };
}