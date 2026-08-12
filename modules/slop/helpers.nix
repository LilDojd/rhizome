{ lib, ... }:
{
  options.slop.mkSkill = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    description = "Build, format, and validate a Pi Agent Skills directory from Nix-managed text.";
  };

  config.slop.mkSkill =
    {
      pkgs,
      name,
      text,
      formatter ? pkgs.prettier,
      formatterArgs ? [
        "--write"
        "--parser"
        "markdown"
      ],
    }:
    assert lib.assertMsg (
      builtins.stringLength name <= 64 && builtins.match "[a-z0-9]+(-[a-z0-9]+)*" name != null
    ) "Skill name must contain at most 64 lowercase alphanumeric or hyphen characters";
    assert lib.assertMsg (builtins.isString text) "Skill text must be a string";
    assert lib.assertMsg (
      formatter == null || lib.isDerivation formatter
    ) "Skill formatter must be a package or null";
    assert lib.assertMsg (builtins.isList formatterArgs) "Skill formatter arguments must be a list";
    pkgs.writeTextFile {
      name = "agent-skill-${name}";
      destination = "/${name}/SKILL.md";
      inherit text;
      checkPhase = ''
        ${lib.optionalString (formatter != null) ''
          ${lib.getExe formatter} ${lib.escapeShellArgs formatterArgs} "$target"
        ''}
        ${pkgs.gnugrep}/bin/grep -Fqx -- ${lib.escapeShellArg "name: ${name}"} "$target"
        ${pkgs.gnugrep}/bin/grep -Eq '^description:[[:space:]]+.' "$target"
      '';
    };
}
