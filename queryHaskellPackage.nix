# Tiny but very useful utility

# EXAMPLE USAGE (nix repl):

# pkgs = import <nixpkgs> {} # Normally with config arg with all the overrides
# ps = pkgs.haskell.packages.ghc861 # or default haskellPackages
# query = import <path-to-this-file>/query-haskell-package.nix
# path = ~/repos/temp/Vinyl/default.nix

# # Fake derivation function producing 'full' default.nix
# fd = p: p

# q = query pkgs fd ps path
# q.version
# # "0.10.0"
# q.libraryHaskellDepends
# # [ null null null ]
# # packages implicitly included with ghc are set to 'null'
# # https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/8.4.2-notes.html#included-libraries
# # (see pkgs/development/haskell-modules/configuration-ghc-x.x.x.nix)

# q.testHaskellDepends
# # [ null «derivation /nix/store/qpacc6n4kjpk6r8jgvmzplpb54xmmzcn-doctest-0.16.0.1.drv» «derivation /nix/store/q6pm6c6cvavgpn8qz6g3aaaar3x7hnzz-hspec-2.5.8.drv» «derivation /nix/store/1bxvbw8552azq7fx3mvkrh27l1fwmsx5-lens-4.17.drv» ...

# A more practical fake derivation:
# gatherDepsAll = # include deps based on the use case (e.g. shell, source tags...)
#   { buildDepends ? []
#   , libraryHaskellDepends ? []
#   , executableHaskellDepends ? []
#   , libraryToolDepends ? []
#   , executableToolDepends ? []
#   , testHaskellDepends ? []
#   , ...}:
#   buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends ++ libraryToolDepends ++ executableToolDepends ++ testHaskellDepends;

stdenv: fakeDerivation: ps: path:
# pkgs: fakeDerivation: ps: path:
let f = import path;
 in # with pkgs;
    f (builtins.intersectAttrs
        (builtins.functionArgs f)
        # ps // {stdenv = stdenv; mkDerivation = fakeDerivation;})
        ps // {inherit stdenv; mkDerivation = fakeDerivation;})
