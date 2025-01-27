{ pkgs
, user
, ...
}: {
  home.packages = with pkgs; builtins.filter (pkg: pkg != null) [ timewarrior ];

  xdg.configFile."sesh/sesh.toml".text = ''
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
