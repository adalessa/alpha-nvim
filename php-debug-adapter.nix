{ pkgs, fetchurl, stdenv }:

# TODO: at some point test a newer version
stdenv.mkDerivation {
  name = "php-debug-adapter";
  version = "1.33.1";

  src = fetchurl {
    url = "https://github.com/xdebug/vscode-php-debug/releases/download/v1.40.0/php-debug-1.40.0.vsix";
    sha256 = "sha256:07cc7de78fe796d45972e5fdcb5358bb926b0c6898c6e3c8352b356e0b429d60";
  };

  buildInputs = [ pkgs.unzip ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    mkdir -p $out/extracted
    unzip $src -d $out/extracted
  '';

  installPhase = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/php-debug-adapter
    echo 'export LD_LIBRARY_PATH=$out/extracted' >> $out/bin/php-debug-adapter
    echo 'exec ${pkgs.nodejs}/bin/node ${placeholder "out"}/extracted/extension/out/phpDebug.js "$@"' >> $out/bin/php-debug-adapter
    chmod +x "$out/bin/php-debug-adapter"
  '';
}

