{ self, inputs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    "mudfish"
    "mudfish-unwrapped"
  ];

  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    lib.optionalAttrs (system == "x86_64-linux") {
      packages.mudfish = pkgs.callPackage ./_mudfish-package.nix { };
      checks.mudfish = import ./_mudfish-test.nix {
        inherit pkgs;
        mudfishModule = self.modules.nixos.mudfish;
        impermanenceModule = inputs.impermanence.nixosModules.impermanence;
      };
    };

  flake.modules.nixos.mudfish = { pkgs, lib, ... }: {
    boot.kernelModules = [ "tun" ];
    environment.persistence."/persistent".directories = [
      {
        directory = "/var/lib/mudfish";
        mode = "0700";
      }
    ];

    # Start explicitly with systemctl; do not redirect game traffic at boot.
    systemd.services.mudfish = {
      description = "Mudfish gaming VPN";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.HOME = "/var/lib/mudfish";
      serviceConfig = {
        ExecStart = "${
          lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.mudfish
        } -B -I -a 127.0.0.1 -P 8282";
        WorkingDirectory = "/var/lib/mudfish";
        StateDirectory = "mudfish";
        StateDirectoryMode = "0700";
        # Upstream aborts if it cannot raise its core dump limit to infinity.
        LimitCORE = "infinity";
        UMask = "0077";
      };
    };
  };
}
