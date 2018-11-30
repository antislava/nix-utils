let namesToNixPathAttrs = import ./namesToNixPathAttrs.nix;
in builtins.mapAttrs (name: import)
(namesToNixPathAttrs ./. [
  "doUnpackSource"
  "extractHaskellSources"
  "fetchGitSmart"
  "fetchNixpkgs"
  "namesToNixPathAttrs"
  "nixPathsToAttrs"
  "pathAttrsToHaskellOver"
  "queryHaskellPackage"
])
