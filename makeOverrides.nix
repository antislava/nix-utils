function: names: haskellPackagesNew: haskellPackagesOld:
  let
    toPackage = name: {
      inherit name;

      value = function haskellPackagesOld.${name};
    };

in
  builtins.listToAttrs (map toPackage names)

