let namesToNixPathAttrs = import ./namesToNixPathAttrs.nix;
in builtins.mapAttrs (name: import)
(namesToNixPathAttrs ./. [
  "doUnpackSource"
  "extractHaskellSources"
  "fetchNixpkgs"
  "namesToNixPathAttrs"
  "nixPathsToAttrs"
  "pathAttrsToHaskellOver"
  "queryHaskellPackage"
])
