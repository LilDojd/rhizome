{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      # PyQt5 omits the ABI declaration required by SIP 6.16.
      python3Packages = pkgs.python3Packages.overrideScope (
        _: previous: {
          pyqt5 = previous.pyqt5.overridePythonAttrs (old: {
            postPatch = old.postPatch + ''
              substituteInPlace sip/QtCore/QtCoremod.sip \
                --replace-fail '%Plugin PyQt5' \
                $'%Plugin PyQt5\n%MinimumABIVersion "12.13"'
            '';
          });
        }
      );
    in
    {
      home.packages = [
        (pkgs.pymol.override { inherit python3Packages; })
      ];
    };
}
