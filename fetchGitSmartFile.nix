json-path: # path to a nix-prefetch-git result
with builtins;
let jsn = fromJSON (readFile json-path);
in import ./fetchGitSmart.nix jsn
