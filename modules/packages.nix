{ inputs, ... }:
{
  den.aspects.packages.hjem = { pkgs, ... }: {
    packages = [
      pkgs.helix
      pkgs.wezterm
      pkgs.git
      # pkgs.zen-browser
      pkgs.firefox
    ];

    files = {
      "helix/config".source = ./modules/config/helix.toml;
      "helix/languages".source = ./modules/config/helix-languages.toml;
    };
  };
}
