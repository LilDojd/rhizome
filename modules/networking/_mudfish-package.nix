{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
}:
let
  version = "6.5.5";
  files = stdenvNoCC.mkDerivation {
    pname = "mudfish-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://mudfish.net/releases/mudfish-${version}-linux-x86_64.sh";
      hash = "sha256-9b8x40v/tiCzAaHycnA4IjdchEQ5ZlitFtbHfTAPAyQ=";
    };

    unpackPhase = ''
      runHook preUnpack
      sh "$src" --noexec --target source
      sourceRoot=source
      runHook postUnpack
    '';
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r bin etc sbin "$out/"
      rm "$out/bin/pkg_linux_setup.sh" "$out/bin/mudrun"
      ln -s mudrun-headless "$out/bin/mudrun"
      ln -s /var/lib/mudfish "$out/var"
      runHook postInstall
    '';

    meta = {
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
buildFHSEnv {
  pname = "mudfish";
  inherit version;
  targetPkgs =
    pkgs: with pkgs; [
      stdenv.cc.cc.lib
      elfutils
      iproute2
      iptables
      ncurses
      net-tools
      openssl
      procps
      zlib
    ];
  multiArch = false;
  # Upstream hardcodes /opt and /sbin paths; keep those inside the FHS environment.
  extraBuildCommands = ''
    mkdir -p "$out/opt/mudfish"
    ln -s ${files} "$out/opt/mudfish/${version}"
  '';
  extraBwrapArgs = [
    "--cap-add CAP_NET_ADMIN"
    "--cap-add CAP_NET_RAW"
  ];
  runScript = "/opt/mudfish/${version}/bin/mudrun-headless";
  meta = {
    description = "Mudfish gaming VPN (headless launcher with local web UI)";
    homepage = "https://mudfish.net/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mudfish";
  };
}
