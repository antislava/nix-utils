# Argument attributes correspond to the output of nix-prefetch-git
{ url # "https://github.com/phadej/github",
, rev # "66eb08c837c20a35ce11b5f719d0d749a087c032",
# , date # Not used "2018-10-25T11:57:44+03:00",
, sha256 # "14c2jx26npa2613vvnz53lwbkq1kvh50v97qdqnw1pjchlhz3avi",
, fetchSubmodules ? false
, archive ? true
, ...
}@arg :
with builtins;
   if (((substring 0 19 url == "https://github.com/")
     || (substring 0 18 url == "http://github.com/"))
     && archive && !fetchSubmodules)
# NOTE: out paths produced are <hash>-source and there is a discussion about it: https://github.com/NixOS/nixpkgs/pull/49862#issuecomment-436585365
   then (fetchTarball {
     url = "${arg.url}/archive/${rev}.tar.gz";
     inherit sha256; })
   # Returns a path string, e.g.
   # "/nix/store/plcs9fjisgffwfpf057wgyiqad5p445r-source"
   # Should we build a set (similar to fetchGet's)?
   else (fetchGit { inherit url rev; })
   # Returns a set, e.g.
   # { outPath = "/nix/store/plcs9fjisgffwfpf057wgyiqad5p445r-source"; rev = "4d81b3652880d09244d7d748ade3933efeb56ed5"; revCount = 60; shortRev = "4d81b36"; }
   # Note the identical path even if the src is fetched from local mirror vs. github!)
   # <the result of fetchGit> + "/subpath" presumes outPath!)))
