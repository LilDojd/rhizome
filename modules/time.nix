{
  flake.modules =
    let
      timeZone = "Asia/Dubai";
    in
    {
      nixos.foundation.services.ntpd-rs.enable = true;
      homeManager.base.home.sessionVariables.TZ = timeZone;
      darwin.foundation.time = { inherit timeZone; };
    };
}
