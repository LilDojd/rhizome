{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      config.animations.enabled = true;

      curve = [
        {
          _args = [
            "linear"
            {
              type = "bezier";
              points = [
                [
                  0
                  0
                ]
                [
                  1
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "md3_standard"
            {
              type = "bezier";
              points = [
                [
                  0.2
                  0
                ]
                [
                  0
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "md3_decel"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.7
                ]
                [
                  0.1
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "md3_accel"
            {
              type = "bezier";
              points = [
                [
                  0.3
                  0
                ]
                [
                  0.8
                  0.15
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "overshot"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "crazyshot"
            {
              type = "bezier";
              points = [
                [
                  0.1
                  1.5
                ]
                [
                  0.76
                  0.92
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "hyprnostretch"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.0
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_decel"
            {
              type = "bezier";
              points = [
                [
                  0.1
                  1
                ]
                [
                  0
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "menu_accel"
            {
              type = "bezier";
              points = [
                [
                  0.38
                  0.04
                ]
                [
                  1
                  0.07
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "easeInOutCirc"
            {
              type = "bezier";
              points = [
                [
                  0.85
                  0
                ]
                [
                  0.15
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "easeOutCirc"
            {
              type = "bezier";
              points = [
                [
                  0
                  0.55
                ]
                [
                  0.45
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "easeOutExpo"
            {
              type = "bezier";
              points = [
                [
                  0.16
                  1
                ]
                [
                  0.3
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "softAcDecel"
            {
              type = "bezier";
              points = [
                [
                  0.26
                  0.26
                ]
                [
                  0.15
                  1
                ]
              ];
            }
          ];
        }
        # use with .2s duration
        {
          _args = [
            "md2"
            {
              type = "bezier";
              points = [
                [
                  0.4
                  0
                ]
                [
                  0.2
                  1
                ]
              ];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 3;
          bezier = "md3_decel";
          style = "popin 60%";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 3;
          bezier = "md3_decel";
          style = "popin 60%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "md3_accel";
          style = "popin 60%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3;
          bezier = "md3_decel";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 3;
          bezier = "menu_decel";
          style = "slide";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1.6;
          bezier = "menu_accel";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 2;
          bezier = "menu_decel";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 4.5;
          bezier = "menu_accel";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 7;
          bezier = "menu_decel";
          style = "slide";
        }
      ];
    };
  };
}
