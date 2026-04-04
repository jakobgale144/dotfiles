{ den, ... }:
{
  den.aspects.packages = { user, ... }: {
    hjem = { pkgs, ... }: {
      packages = [
        # pkgs.yazelix
        # pkgs.helix # included with yazelix's flake
        pkgs.nushell
        pkgs.wezterm
        pkgs.git
        # pkgs.zen-browser
        pkgs.firefox
        pkgs.github-cli
        pkgs.obsidian
      ];

      files = {
        ".config/helix/config.toml".source = ./config/helix.toml;
        ".config/helix/languages.toml".source = ./config/helix-languages.toml;

        ".config/nushell/env.nu".text = ''
          $env.EDITOR = "hx";
          $env.VISUAL = "hx";
        '';
      };

      # environment.sessionVariables = {
      #   EDITOR = "hx";
      #   VISUAL = "hx";
      #   FOO = "bar";
      # };
    };

    nixos = { pkgs, ... }: {
      users.users.${user.userName}.shell = pkgs.nushell;
    };
  };
}
