{
  den.aspects.packages.hjem = { pkgs, ... }: {
    packages = [
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
}
