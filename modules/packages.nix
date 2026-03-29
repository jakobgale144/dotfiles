{
  den.aspects.packages.hjem = { user, pkgs, ... }: {
    ${user.userName}.packages = [
      pkgs.helix
      pkgs.wezterm
      # pkgs.git
      pkgs.zenbrowser
    ];

    ${user.userName}.files = {
      "helix/config".source = "./config/helix.toml";
      "helix/languages".source = "./config/helix-languages.toml";
    };
  };
}
