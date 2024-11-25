{ pkgs, user, ... }: {
  home.packages = with pkgs; builtins.filter (pkg: pkg != null) [ sesh ];

  xdg.configFile."sesh/sesh.toml".text = ''
    [default_session]
    startup_command = "nvim -c ':Telescope find_files'"

    [[session]]
    name = "Downloads 📥"
    path = "~/Downloads"
    startup_command = "yazi"

    [[session]]
    name = "Home 🏡"
    path = "/Users/${user}"
    startup_command = "l"
  '';
}
