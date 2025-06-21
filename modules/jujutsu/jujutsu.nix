{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.modules.homeManager.base =
    homeArgs@{ pkgs, ... }:
    {
      programs.jujutsu = {
        enable = true;
        package = inputs.jujutsu.packages.${pkgs.system}.default;
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
