{
  stdenv,
  dpkg,
  glibc,
  gcc-unwrapped,
  libnl,
  openssl,
  zlib,
  autoPatchelfHook,
}: let
  version = "7.06.0";
  src = ./falcon-sensor_7.06.0-16108_amd64.deb;
in
  stdenv.mkDerivation {
    name = "falcon-sensor-${version}";
    system = "x86_64-linux";

    inherit src;

    # required for compilation
    nativeBuildInputs = [
      autoPatchelfHook # automatically setup the loader, and do the magic
      dpkg
    ];

    # required at running time
    buildInputs = [
      gcc-unwrapped
      glibc
      libnl
      openssl
      zlib
    ];

    unpackPhase = "true";

    # Extract and copy executable in $out/bin
    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out
      cp -av $out/opt/CrowdStrike/* $out
      rm -rf $out/opt
    '';

    meta = with stdenv.lib; {
      description = "CrowdStrike Falcon";
      homepage = https://www.crowdstrike.com/falcon-platform/;
      # license = licenses.mit;
      maintainers = with stdenv.lib.maintainers; [];
      platforms = ["x86_64-linux"];
    };
  }
