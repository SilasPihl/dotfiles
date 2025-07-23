{ pkgs, ... }: {
  home.file.".config/sesh/sesh.toml".text = ''
    [[session]]
    name = "lix"
    path = "~/git/lix-one/lix-one"
    windows = ["zsh", "claude", "backend", "frontend"]

    [[window]]
    name = "zsh"
    startup_command = "zsh"

    [[window]]
    name = "claude"
    startup_command = "zsh"

    [[window]]
    name = "backend"
    startup_command = "zsh"
    panes = [
      { command = "zsh" },
      { command = "zsh" },
      { command = "zsh" },
      { command = "zsh" }
    ]
    layout = "tiled"

    [[window]]
    name = "frontend"
    startup_command = "zsh"
    panes = [
      { command = "zsh" },
      { command = "zsh" },
      { command = "zsh" },
      { command = "zsh" }
    ]
    layout = "tiled"
  '';
}