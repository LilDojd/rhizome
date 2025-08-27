{ lib, config, ... }:
let
  reachableNixoss =
    config.flake.nixosConfigurations
    |> lib.filterAttrs (
      _name: nixos:
      !(lib.any isNull [
        nixos.config.networking.domain
        nixos.config.networking.hostName
        nixos.config.services.openssh.publicKey
      ])
    );
in
{
  flake.modules = {
    nixos.foundation = {
      options.services.openssh.publicKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      config = {
        services.openssh = {
          enable = true;
          openFirewall = true;

          settings = {
            PasswordAuthentication = false;
          };

          extraConfig = ''
            Include /etc/ssh/sshd_config.d/*
          '';
        };

        programs.ssh.knownHosts =
          reachableNixoss
          |> lib.mapAttrs (
            _name: nixos: {
              hostNames = [ nixos.config.networking.fqdn ];
              inherit (nixos.config.services.openssh) publicKey;
            }
          );
      };
    };

    nixos.agenix = {

      services.openssh = {
        hostKeys = [
          {
            type = "ed25519";
            path = "/persistent/etc/ssh/ssh_host_ed25519_key";
          }
          {
            type = "rsa";
            bits = 4096;
            path = "/persistent/etc/ssh/ssh_host_rsa_key";
          }
        ];
      };
    };

    darwin.foundation = {
      config = {
        programs.ssh = {
          knownHosts =
            reachableNixoss
            |> lib.mapAttrs (
              _name: nixos: {
                hostNames = [ nixos.config.networking.fqdn ];
                publicKey = nixos.config.services.openssh.publicKey;
              }
            );

          extraConfig = ''
            Host *
              SendEnv TERM
          '';
        };
      };
    };

    homeManager.base = args: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        includes = [ "${args.config.home.homeDirectory}/.ssh/hosts/*" ];

        matchBlocks = lib.mkMerge (
          [
            {
              "*" = {
                setEnv.TERM = "xterm-256color";
                compression = true;
                hashKnownHosts = false;
              };
            }
          ]
          ++ (lib.mapAttrsToList (_: nixos: {
            "${nixos.config.networking.fqdn}" = {
              identityFile = "~/.ssh/keys/rhizome_ed25519";
            };
          }) reachableNixoss)
        );
      };
    };
  };
}
