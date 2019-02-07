# Initial source: https://github.com/awakesecurity/nix-deploy/blob/master/nix/fetchNixpkgs.nix
{ url ? "https://github.com/NixOS/nixpkgs" # can be nixpkgs-channel
, rev                             # The Git revision of nixpkgs to fetch
, sha256                          # The SHA256 hash of the unpacked archive
, system ? builtins.currentSystem # This is overridable if necessary
, name ? "nixpkgs"
, patches ? []
, ...
}:
let
  pkgs = import <nixpkgs> {};
  # revabbr = builtins.substring 0 6 rev;
  pkgsrc =
  if ((builtins.substring 0 18 url == "https://github.com")
  || ( builtins.substring 0 17 url == "http://github.com"))
  then (
      builtins.fetchTarball {
        url = "${url}/archive/${rev}.tar.gz";
        inherit sha256;
      })
  else (
    builtins.fetchGit { inherit url; inherit rev; }
  );
# in nixpkgs
# in pkgs.runCommand ("nixpkgs-" + nixpkgs.rev) {inherit nixpkgs patches; } ''
in pkgs.runCommand "${name}-${rev}" {inherit pkgsrc patches; } ''
  cp -r $pkgsrc $out
  chmod -R +w $out
  for p in $patches ; do
    echo "Applying patch $p"
    patch -d $out -p1 < "$p"
  done
''
