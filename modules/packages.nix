{ den, ... }:
{
  den.aspects.packages = {
    includes = [
      ( den._.user-shell "nushell" )
    ];

    hjem = { pkgs, ...}: {
      packages = [
        # pkgs.yazelix
        pkgs.helix
        pkgs.wezterm
        pkgs.git
        # pkgs.zen-browser
        pkgs.firefox
        pkgs.github-cli
      ];

      files = {
        ".config/helix/config.toml".source = ./config/helix.toml;
        ".config/helix/languages.toml".source = ./config/helix-languages.toml;
      };
    };
  };
}
