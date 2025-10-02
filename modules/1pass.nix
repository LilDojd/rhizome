{
  config,
  lib,
  ...
}:
{
  nixpkgs.allowedUnfreePackages = [
    "1password"
    "1password-cli"
    "1password-gui"
  ];

  flake.modules =
    let
      flakeCommon =
        { pkgs, ... }:
        let
          username = config.flake.meta.owner.username;
        in
        {
          programs._1password.enable = true;

          programs._1password-gui = {
            enable = true;
          }
          // lib.optionalAttrs (pkgs.stdenv.isLinux) {
            polkitPolicyOwners = [ username ];
          };
        };
    in
    {
      homeManager.base =
        { pkgs, ... }:
        let
          onePassPath =
            if pkgs.stdenv.isDarwin then
              ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"''
            else
              "~/.1password/agent.sock";
        in
        {
          programs.ssh = {
            extraConfig = ''
              Host *
                IdentityAgent ${onePassPath}
            '';
          };
        };

      homeManager.hyprland = {

        xdg.desktopEntries = {
          "1password" = {
            name = "1Password";
            genericName = "Password Manager";
            exec = "1password --ozone-platform=x11 %U";
            terminal = false;
            type = "Application";
            icon = "1password";
            categories = [
              "Utility"
              "Security"
            ];
            mimeType = [
              "x-scheme-handler/onepassword"
              "x-scheme-handler/op"
            ];
          };
        };
      };

      nixos.foundation = {
        imports = [ flakeCommon ];
      };

      darwin.foundation = {
        imports = [ flakeCommon ];
      };
    };
}
