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
            email = config.flake.meta.owner.email;
            name = config.flake.meta.owner.githubUsername;
          };
          colors = {
            change_id = "#04a5e5";
            commit_id = {
              fg = "#40a02b";
              bold = true;
            };
          };
          ui = {
            editor = "hx";
            pager = "delta";
          };
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
                command = [ "${pkgs.nixfmt-classic}/bin/nixfmt" ];
                patterns = [ "glob:'**/*.nix'" ];
              };
            };
          };
        };
      };
    };
}
