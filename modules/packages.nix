{
  den.aspects.packages.hjem = { user, pkgs, ... }: {
    packages = [
      pkgs.helix
      pkgs.wezterm
      # pkgs.git
      pkgs.zenbrowser
    ];

    files = {
      "helix/config".source = "./config/helix.toml";
      "helix/languages".source = "./config/helix-languages.toml";
    };
  };
}
