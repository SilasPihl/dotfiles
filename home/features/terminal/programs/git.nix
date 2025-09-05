{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Silas Pihl";
    userEmail = "silaspihl@gmail.com";
    signing = {
      signByDefault = true;
      key = "23E6EAD9D5C1D853";
    };
    aliases = {
      st = "status";
      c = "commit --signoff --message";
      p = "push";
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
        condition = "gitdir:~/repos/lix-one";
        contents = {
          user = {
            email = "silas@lix.one";
          };
          commit = {
            gpgSign = false;
          };
        };
      }
      {
        condition = "gitdir:~/repos/lix/*";
        contents = {
          user = {
            email = "silas@lix.one";
          };
          commit = {
            gpgSign = false;
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