Unsorted collection of nix functions (primarily for haskell development and scripting in nix shell).

## To-do's and outstanding issues

### Extracting dependencies for custom shells

There is a nice function `shellFor` for quickly preparing a shell.nix for a multi-package `cabal.project` projects (in `development/haskell-modules/lib.nix`). Can/should it be used instead?


### Overriding all packages

What is the correct way to override *all* haskell package with certain flag (e.g. `doCheck = false` as first step in the development in the new environement) en mass.
* [compiling - Nix: Skipping unit tests when installing a Haskell package - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/166804/nix-skipping-unit-tests-when-installing-a-haskell-package#287487)
