{
  flake.modules =
    let
      timeZone = "Asia/Dubai";
    in
    {
      nixos.pc.services.ntpd-rs.enable = true;
      homeManager.base.home.sessionVariables.TZ = timeZone;
      darwin.pc.time = { inherit timeZone; };
    };
}
