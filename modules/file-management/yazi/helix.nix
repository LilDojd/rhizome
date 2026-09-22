{ lib, ... }:
{
  flake.modules.homeManager.base = hmArgs: {
    # https://yazi-rs.github.io/docs/tips/#helix
    # Steelix requires a trusted workspace to execute these shell commands.
    programs.nhx.settings.keys.normal."C-y" = [
      ":sh rm -f /tmp/unique-file"
      '':insert-output ${lib.getExe hmArgs.config.programs.yazi.package} "%{buffer_name}" --chooser-file=/tmp/unique-file''
      '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
      ":open %sh{cat /tmp/unique-file}"
      ":redraw"
      ":set mouse false"
      ":set mouse true"
    ];
  };
}
