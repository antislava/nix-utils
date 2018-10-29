paths:
  with builtins;
  let
    basenameMatches = match "^.*/([^/]+)\\.nix$";
    toKeyVal = p:
    {
      name  = head (basenameMatches (toString p));
      value = p;
    };
  in
    listToAttrs (map toKeyVal paths)
