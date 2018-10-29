# USAGE (nix repl):
# rc = import ./. {} # reflex project derivation (normally default.nix)
# unpck = import nix-tags/do-unpack-source.nix
# :b unpck rc.ghc.zenc rc.reflex.nixpkgs

pkg@{ name, src, ... }:
  {pkgs ? import <unstable> {}, ...}:
# using pkgs/build-support/fetchzip/default.nix as a starting point
let
  isUnpacked = builtins.typeOf src == "string" || builtins.typeOf src == "path" || ! ( pkgs.stdenv.lib.hasSuffix ".tar.gz" src.outPath );
  # "path" type applies only to unquoted strings (can path with whitespaces every have tpe "path"?!)
in with pkgs; derivation rec {
  # TODO: switch to stdenv.mkDerivation
  name = pkg.name + "-source";
  builder = "${bash}/bin/bash";
  pre = ''
    declare -xp
    export PATH="${xz}/bin:${gnutar}/bin:${gzip}/bin:${coreutils}/bin"
  '';
  link = pre + ''
    ln -sf "${src}" $out
  '';
  unpack = pre + ''
    unpackDir=$TEMPDIR
    mkdir -p $unpackDir
    tar -xf "${src}" -C $unpackDir
    if [ $(ls "$unpackDir" | wc -l) != 1 ]; then
      echo "error: The archive must contain a single file or directory."
      echo "hint: Check the tmp directory manually and pkg.src in nix repl"
      exit 1
    fi
    fn=$(cd "$unpackDir" && echo *)
    if [ -f "$unpackDir/$fn" ]; then
      mkdir $out
    fi
    mv "$unpackDir/$fn" "$out"
    exit 0
  '';

  args = [ "-c" (if isUnpacked then link else unpack) ];
  inherit coreutils src isUnpacked;
  system = builtins.currentSystem;
}
