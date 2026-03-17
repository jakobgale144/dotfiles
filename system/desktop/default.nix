{
  pkgs,
  myvars,
  ...
}:
{
  imports = [ ./nirx ];

  services.xserver.enable = false;
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
    settings.default_session.user = myvars.username;
  };
}
