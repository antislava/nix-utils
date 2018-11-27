Unsorted collection of nix functions (primarily for haskell development and scripting in nix shell).

## TODO: Update after changing naming convention (to the CamelCase)

## Overview

### General
[fetchNixpkgs.nix](fetchNixpkgs.nix) - Fetch a specific snapshot of `nixpkgs`. Necessary for reproducibility

### Haskell package soruce extraction
[do-unpack-source.nix](do-unpack-source.nix)
[extract-haskell-sources.nix](extract-haskell-sources.nix)

### Haskell package soruce extraction
[makeOverrides.nix](makeOverrides.nix) - Apply a given override function to a list packages
[query-haskell-package.nix](query-haskell-package.nix) - Extract components of the standard haskell package `default.nix`
[callFromDirectory.nix](callFromDirectory.nix) - call packages from a directory given a package name list
[readDirectory.nix](readDirectory.nix) - call *all* functions from a directory


## To-do's and outstanding issues

### Extracting dependencies for custom shells

There is a nice function `shellFor` for quickly preparing a shell.nix for a multi-package `cabal.project` projects (in `development/haskell-modules/lib.nix`). Can/should it be used instead?


### Overriding all packages

What is the correct way to override *all* haskell package with certain flag (e.g. `doCheck = false` as first step in the development in the new environement) en mass.
* [compiling - Nix: Skipping unit tests when installing a Haskell package - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/166804/nix-skipping-unit-tests-when-installing-a-haskell-package#287487)
