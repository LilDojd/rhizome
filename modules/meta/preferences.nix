_: {
  flake = {
    meta.owner.preferences = {
      layout = [
        "us"
        "ru"
      ];
      keymap = "us";
      monitors = [
        {
          output = "DP-4";
          mode = "3840x2160@240";
          position = "0x0";
          scale = 1.5;
        }
        {
          output = "DP-3";
          mode = "3840x2160@144";
          position = "2560x-560";
          scale = 1.5;
          transform = 1;
        }
      ];
    };
  };
}
