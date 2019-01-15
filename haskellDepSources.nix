{ pkgs ? import <nixpkgs> {}
, hpkgs # Haskell package set of the same type as (import <nixpkgs> {}).haskellPackages BUT with target packages(!)
# Reflex example: hpkgs = (import ./. {}).ghc (or .ghcjs)
# Regular haskell project ex: hpkgs = (import <nixpkgs> {}).haskellPackages.override {overrides = self: _: rec { myproj = self.callPackage ./myproj.nix {};};}
  # => ghcWithDeps = hpkgs.ghcWithPackages (ps: [ ps.myproj ])
, targets ? ps: with ps; [ common frontend backend ]
}:
# USAGE EXAMPLES (reflex-frp/obelisk project):
# nix-build nix-utils/haskell-sources.nix --arg hpkgs '(import ./. {}).ghc' --arg targets 'p: [ p.common p.frontend p.frontend ]' --out-link hsources-ghc
# nix-build --expr 'import ./nix-utils/haskell-sources.nix { hpkgs = (import ./. {}).ghcjs; targets = ps: with ps; [ common frontend ]; }' --out-link "hsources-ghcjs"
let
  doUnpackSource        = import ./doUnpackSource.nix;
  extractHaskellSources = import ./extractHaskellSources.nix;
  targetPaths = targets hpkgs;
  targetNames = map (p: p.pname) targetPaths;
  ghcWithDeps = hpkgs.ghcWithPackages targets;
  srcPaths = with builtins;
    if   hasAttr "paths" ghcWithDeps
    then filter (hasAttr "pname") ghcWithDeps.paths
    else [];
  srcPathsEx = with builtins;
    filter (p: !(elem p.pname targetNames)) srcPaths;
  packageSources =
    map (p: {src = "${doUnpackSource p pkgs}"; nm = p.name;}) srcPathsEx;
in
  extractHaskellSources pkgs packageSources
