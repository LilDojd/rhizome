{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    # TODO: Remove after https://github.com/Cretezy/lazyjj/pull/159 is merged
    let
      lazyjj-patched = pkgs.lazyjj.overrideAttrs (
        finalAttrs: oldAttrs: rec {
          src = pkgs.fetchFromGitHub {
            owner = "dotdash";
            repo = "lazyjj";
            rev = "889e99db8d4609cbb0a7ad211468026c1f045608";
            hash = "sha256-+9dhpN9BA0gr3N4E5twIyATvWGW5eptNOyK/EM64GcQ=";
          };
          cargoDeps = oldAttrs.cargoDeps.overrideAttrs (oldAttrs: {
            vendorStaging = oldAttrs.vendorStaging.overrideAttrs {
              inherit (finalAttrs) src;
              outputHash = "sha256-bQNLhQAUw2JgThC+RiNC5ap8D6a4JgflV2whXKu7QF8=";
            };
          });
        }
      );
    in
    {
      home.packages = [
        lazyjj-patched
      ];
      home.shellAliases.lj = "lazyjj";
    };
}
