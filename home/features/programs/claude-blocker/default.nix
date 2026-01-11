{ lib, stdenv, nodejs_22, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "claude-blocker";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper nodejs_22 ];

  buildPhase = ''
    export HOME=$TMPDIR
    npm ci
    npm run build
  '';

  installPhase = ''
    mkdir -p $out/lib/claude-blocker $out/bin
    cp -r dist/* $out/lib/claude-blocker/
    cp -r node_modules $out/lib/claude-blocker/

    makeWrapper ${nodejs_22}/bin/node $out/bin/claude-blocker \
      --add-flags "$out/lib/claude-blocker/index.js"
  '';

  meta = {
    description = "Track Claude Code session states via hooks";
    license = lib.licenses.mit;
    mainProgram = "claude-blocker";
  };
}
