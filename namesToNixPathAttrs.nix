dir: names:
  let
    toNamePath = name: {
      name  = name;
      # value = builtins.toPath (dir + "/${name}.nix");
      # builtins.toPath still returns a String but requires the ABSOLUTE path format while in nix scripts relative form is used to e.g. import
      value = dir + "/${name}.nix"; # this does return a path somehow :o!
    };
  in
    builtins.listToAttrs (map toNamePath names)
