{
  gitUsername = "Georgy Andreev";
  gitEmail = "yawner@pm.me";

  consoleKeyMap = "us";
  keyboardLayout = "us,ru";

  terminal = "ghostty";
  browser = "firefox";

  stylixImage = ../../wallpapers/spacegoose.png;

  animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  MonitorSettings = ''
    monitor=DP-2,3840x2160@144,0x0,1.5
    monitor=HDMI-A-2,3840x2160@60,2560x-980,1.25,transform,3
  '';

  # MonitorSettings = ''
  # monitor=,preferred,auto,1
  # '';
}
