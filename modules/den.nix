{ inputs, den, lib, ... }: {
  imports = [ inputs.den.flakeModule ]; # (1)

  # den.schema.user.classes = lib.mkDefault [ "homeManager" ]; # (2)

  # den.default.homeManager.home.stateVersion = "25.11"; # (3)
  # den normal state version?

  den.hosts.x86_64-linux.test-laptop.users.test = {
    # groups = [ "wheel" ]; # Is this valid?
    # classes = [ "hjem" ]; # Is this pointing to a hjem.nix? An object? Or is Hjem a hard-coded value?
  }; # (4) (5)

  den.aspects.test-laptop = { # (6)
    includes = [ den.provides.hostname ]; # (7)
    nixos = { pkgs, ... }: {
      imports = [ ./_nixos/configuration.nix ]; # (8)
      environment.systemPackages = [ pkgs.hello ];
    };
  };

  den.aspects.tux = { # (9)
    includes = [ den.provides.define-user den.provides.primary-user ]; # (10)
    # homeManager = { pkgs, ... }: {
    #   home.packages = [ pkgs.vim ];
    # };
  };
}
