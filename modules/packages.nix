{
  den.aspects.packages.hjem = { pkgs, ... }: {
    packages = [
      pkgs.helix
      pkgs.wezterm
      # pkgs.git
      pkgs.zen-browser
    ];

    files = {
      "helix/config".source = "./config/helix.toml";
      "helix/languages".source = "./config/helix-languages.toml";
    };
  };
}
