pathAttrs:
haskellPackagesNew: haskellPackagesOld:
  let
    toOver = name: value:
      haskellPackagesNew.callPackage value { };
  in
    builtins.mapAttrs toOver pathAttrs

# NOTE:
# mapAttrs is a new built in (from nix-2.1)
# https://nixos.org/nix/manual/#ssec-relnotes-2.1
# https://github.com/NixOS/nix/blob/master/tests/lang/eval-okay-mapattrs.nix


