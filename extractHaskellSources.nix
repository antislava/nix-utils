pkgs: package-srcs:
with pkgs;
# TODO: switch to stdenv.mkDerivation
derivation rec {
  name = "haskell-sources";
  builder = "${bash}/bin/bash";
  pre = ''
    declare -xp
    export PATH="${coreutils}/bin"
    mkdir $out
    cd $out
  '';
  links = pre +
  builtins.concatStringsSep "\n"
   ( map ( s: "ln -s ${s.src} ${s.nm}" ) package-srcs )
  ;
  args = [ "-c" links ];
  system = builtins.currentSystem;
}
