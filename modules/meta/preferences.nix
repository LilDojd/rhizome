_: {
  flake = {
    meta.owner.preferences = {
      layout = "us,ru";
      keymap = "us";
      monitorSettings = ''
        monitor=DP-1,3840x2160@144,0x0,1.5
        monitor=HDMI-A-1,3840x2160@60,2560x-980,1.25,transform,3
      '';
    };
  };
}
