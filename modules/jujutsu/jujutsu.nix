{
  lib,
  config,
  ...
}:
{
  flake.modules.homeManager.base =
    homeArgs@{ pkgs, ... }:
    {
      programs.jujutsu = {
        enable = true;
        package = pkgs.jujutsu;
        settings = {
          user = {
            inherit (config.flake.meta.owner) email;
            name = config.flake.meta.owner.githubUsername;
          };
          colors = {
            change_id = "#04a5e5";
            commit_id = {
              fg = "#40a02b";
              bold = true;
            };
          };
          signing = {
            behavior = "own";
            backend = "ssh";
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESOx5jXSV+jeGmIpVO3ASIByLflNIhnkfAlmXOnMsXk";
          };
          templates = {
            commit_trailers = ''
              format_signed_off_by_trailer(self)
              ++ if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'';
          };
          git.sign-on-push = true;
          ui.show-cryptographic-signatures = true;
          ui.editor = lib.mkIf homeArgs.config.programs.helix.enable "hx";
          git = {
            private-commits = "description(glob:'private:*')";
          };
          fix = {
            tools = {
              rustfmt = {
                enabled = true;
                command = [
                  "${pkgs.rustfmt}/bin/rustfmt"
                  "--emit"
                  "stdout"
                ];
                patterns = [ "glob:'**/*.rs'" ];
              };
              nixfmt = {
                enabled = true;
                command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
                patterns = [ "glob:'**/*.nix'" ];
              };
            };
          };
        };
      };
    };
}
