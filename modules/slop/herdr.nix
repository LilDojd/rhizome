{ inputs, config, ... }:
{
  flake.modules.homeManager.slop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr ];

      programs.pi.coding-agent = {
        skills = [
          (config.slop.mkSkill {
            inherit pkgs;
            name = "herdr";
            text = builtins.readFile (inputs.herdr + "/skills/herdr/SKILL.md");
          })
        ];
        extensions = [ (inputs.herdr + "/src/integration/assets/pi/herdr-agent-state.ts") ];
      };
    };
}
