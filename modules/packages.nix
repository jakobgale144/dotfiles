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
      "helix/config".source = inputs.self + /config/helix.toml;
      "helix/languages".source = inputs.self + /config/helix-languages.toml;
    };
  };
}
