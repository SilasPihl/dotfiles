{ pkgs
, user
, ...
}: 
let
  theme = ./../../../themes/timewarrior;
in
{
  home.packages = with pkgs; builtins.filter (pkg: pkg != null) [ timewarrior ];

  home.file.".timewarrior/timewarrior.cfg".text = ''
    import ${toString theme}/catppuccin.theme
  '';
}