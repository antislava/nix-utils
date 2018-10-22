directory: names:

haskellPackagesNew: haskellPackagesOld:
  let
    # haskellPaths = builtins.attrNames (builtins.readDir directory);
    toKeyVal = name: {
      name  = name;
      value = haskellPackagesNew.callPackage (directory + "/${name}.nix") { };
    };

  in
    builtins.listToAttrs (map toKeyVal names)
