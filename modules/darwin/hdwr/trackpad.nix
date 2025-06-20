{
  flake.modules.darwin.pc = {
    system.defaults = {
      trackpad = {

        # Enable two finger right click
        TrackpadRightClick = true;

        # Enable three finger drag
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
