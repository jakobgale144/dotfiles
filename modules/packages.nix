{ den, ... }:
{
  den.aspects.packages = { user, ... }: {
    hjem = { pkgs, ... }: {
      packages = [
        # pkgs.yazelix
        pkgs.helix
        pkgs.nushell
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

      environment.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
        FOO = "bar";
      };

      user = { pkgs, ... }: {
        shell = pkgs.nushell;
      };
    };

    nixos = { pkgs, ... }: {
      # users.users.${user.userName} = {
      #   shell = pkgs.nushell;
      # };
      # environment.sessionVariables.FOO = "bar";
    };
  };
}
