{
  flake.modules.darwin.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ pam-reattach ];

      security.pam.services.sudo_local.touchIdAuth = true;
    };
}
