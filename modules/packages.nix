{ den, ... }:
{
  den.aspects.packages = { user, pkgs, ... }: {
    hjem.packages = [
      # pkgs.yazelix
      pkgs.helix
      pkgs.nushell
      pkgs.wezterm
      pkgs.git
      # pkgs.zen-browser
      pkgs.firefox
      pkgs.github-cli
    ];

    hjem.files = {
      ".config/helix/config.toml".source = ./config/helix.toml;
      ".config/helix/languages.toml".source = ./config/helix-languages.toml;
    };

    hjem.environment.sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    nixos.users.users.${user.userName}.shell = pkgs.nushell;
  };
}
