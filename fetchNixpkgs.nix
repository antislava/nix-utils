# Initial source: https://github.com/awakesecurity/nix-deploy/blob/master/nix/fetchNixpkgs.nix
{ url ? "https://github.com/NixOS/nixpkgs"
, rev                             # The Git revision of nixpkgs to fetch
, sha256                          # The SHA256 hash of the unpacked archive
, system ? builtins.currentSystem # This is overridable if necessary
, ...
}:

if ((builtins.substring 0 18 url == "https://github.com")
|| ( builtins.substring 0 17 url == "http://github.com"))

then (
  if (0 <= builtins.compareVersions builtins.nixVersion "1.12")

# In Nix 1.12, we can just give a `sha256` to `builtins.fetchTarball`.
  then (
    builtins.fetchTarball {
      url = "${url}/archive/${rev}.tar.gz";
      inherit sha256;
    })

# This hack should at least work for Nix 1.11
  else (
    (rec {
      tarball = import <nix/fetchurl.nix> {
        url    = "${url}/archive/${rev}.tar.gz";
        sha256 = null;
      };

      builtin-paths = import <nix/config.nix>;

      script = builtins.toFile "nixpkgs-unpacker" ''
        "$coreutils/mkdir" "$out"
        cd "$out"
        "$gzip" --decompress < "$tarball" | "$tar" -x --strip-components=1
      '';

      nixpkgs = builtins.derivation ({
        name = "nixpkgs-${builtins.substring 0 6 rev}";

        builder = builtins.storePath builtin-paths.shell;

        args = [ script ];

        inherit tarball system;

        tar       = builtins.storePath builtin-paths.tar;
        gzip      = builtins.storePath builtin-paths.gzip;
        coreutils = builtins.storePath builtin-paths.coreutils;
      } // (if null == sha256 then { } else {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = sha256;
      }));
    }).nixpkgs))

else (
  builtins.fetchGit { inherit url; inherit rev; }
)
