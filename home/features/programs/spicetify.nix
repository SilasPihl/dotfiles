{ pkgs, user, ... }: {
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [ spicetify-cli ];

  # Follow https://github.com/catppuccin/spicetify?tab=readme-ov-file#usage to set the theme of Spotify.
  xdg.configFile."spicetify/config.xpui.ini".text = ''
    [Additional Options]
    extensions            =
    custom_apps           = marketplace
    sidebar_config        = 1
    home_config           = 1
    experimental_features = 1

    [Patch]

    [Setting]
    spotify_path           = /Applications/Nix Apps/Spotify.app/Contents/Resources
    current_theme          = marketplace
    inject_theme_js        = 1
    inject_css             = 1
    overwrite_assets       = 0
    always_enable_devtools = 0
    prefs_path             = /Users/${user}/Library/Application Support/Spotify/prefs
    color_scheme           =
    replace_colors         = 1
    spotify_launch_flags   =
    check_spicetify_update = 1

    [preprocesses]
    disable_sentry     = 1
    disable_ui_logging = 1
    remove_rtl_rule    = 1
    expose_apis        = 1

    ; do not change!
    [backup]
    version = 1.2.49.439.gfae492c7
    with    = 2.38.3
  '';
}
