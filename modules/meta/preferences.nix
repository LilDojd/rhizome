_: {
  flake = {
    meta.owner.preferences = {
      layout = [
        "us"
        "ru"
      ];
      keymap = "us";
      monitorSettings = ''
        monitor=DP-4,3840x2160@240,0x0,1.5
        monitor=DP-3,3840x2160@144,2560x-560,1.5,transform,1
      '';
    };
  };
}
