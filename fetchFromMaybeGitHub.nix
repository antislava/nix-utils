pkgs:
json-path: # path to a nix-prefetch-git result
with builtins;
let jsn = fromJSON (readFile json-path);
in if ((substring 0 19 jsn.url == "https://github.com/")
    || (substring 0 18 jsn.url == "http://github.com/"))
   then (pkgs.fetchFromGitHub {
     url = "${jsn.url}/archive/${jsn.rev}.tar.gz";
     inherit (jsn) sha256; })
   # Returns a path string, e.g.
   # "/nix/store/plcs9fjisgffwfpf057wgyiqad5p445r-source"
   # Should we build a set (similar to fetcGet's)?
   else (fetchGit { inherit (jsn) url rev; })
   # Returns a set, e.g.
   # { outPath = "/nix/store/plcs9fjisgffwfpf057wgyiqad5p445r-source"; rev = "4d81b3652880d09244d7d748ade3933efeb56ed5"; revCount = 60; shortRev = "4d81b36"; }
   # Note the identical path even if the src is fetched from local mirror vs. github!)
   # <the result of fetchGit> + "/subpath" presumes outPath!)))
