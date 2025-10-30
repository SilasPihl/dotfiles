{ lib, stdenv, fetchzip, undmg, unzip }:

stdenv.mkDerivation rec {
  pname = "hammerspoon";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    hash = "sha256-CuTFI9qXHplhWLeHS7bgZJolULbg9jQRyT6MTKzkQqs=";
    stripRoot = false;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Hammerspoon.app $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org/";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = [ ];
  };
}
