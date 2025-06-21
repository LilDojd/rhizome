{
  inputs,
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
        { config, pkgs, ... }:
        let
          username = config.flake.meta.owner.username;
        in
        {
          programs._1password.enable = true;

          programs._1password-gui =
            {
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
          onePassPath = "~/.1password/agent.sock";
        in
        {
          imports = [ inputs._1password-shell-plugins.hmModules.default ];

          programs._1password-shell-plugins = {
            enable = true;
            plugins = with pkgs; [
              gh
              awscli2
              cachix
            ];

          };

          programs.ssh = {
            extraConfig = ''
              Host *
                  IdentityAgent ${onePassPath}
            '';
          };
        };

      nixos.pc =
        {
          imports = [ flakeCommon ];
        };

      darwin.pc =
        {
          imports = [ flakeCommon ];
        };
    };
}
