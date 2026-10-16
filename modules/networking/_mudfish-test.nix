{
  pkgs,
  mudfishModule,
  impermanenceModule,
}:
pkgs.testers.runNixOSTest {
  name = "mudfish";
  nodes.machine = {
    imports = [
      mudfishModule
      impermanenceModule
    ];
    environment.persistence."/persistent".enable = false;
    virtualisation.memorySize = 1024;
  };
  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.fail("systemctl is-active mudfish.service")
    machine.succeed("systemctl start mudfish.service")
    machine.wait_for_open_port(8282)
    machine.succeed("curl -fsS http://127.0.0.1:8282/ > /dev/null")
    machine.succeed("test $(stat -c %a /var/lib/mudfish) = 700")
    machine.succeed("systemctl stop mudfish.service")
    machine.wait_for_closed_port(8282)
    machine.succeed("systemctl start mudfish.service")
    machine.wait_for_open_port(8282)
    machine.succeed("curl -fsS http://127.0.0.1:8282/ > /dev/null")
  '';
}
