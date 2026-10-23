{
  flake.modules.nixos.foundation = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      settings.publish = {
        disable-publishing = false;
        publish-addresses = true;
      };
    };
    services.resolved.enable = true;
  };
}
