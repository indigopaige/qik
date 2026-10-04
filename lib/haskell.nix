{ system
, pkgs
, ...
}:
rec {
  defaultGhcv = "9124";

  mk =
    { sourceOverrides ? {}
    , ghcv ? defaultGhcv
    , target ? "native"
    , tool ? (_: [])
    , libs ? (_: [])
    , name
    , root
    , ...
    }:

    let
      ghcr = "ghc${ghcv}";

      ghcp =
        if target == "js"
        then pkgs.pkgsCross.ghcjs.haskell.packages.${ghcr}
        else pkgs.haskell.packages.${ghcr};

      t =
        [
          ghcp.ghc
          pkgs.cabal-install
          pkgs.hpack
        ]
        ++ tool pkgs;

      l = libs pkgs;
    in
      ghcp.developPackage {
        modifier = drv:
          pkgs.haskell.lib.addExtraLibraries
            (pkgs.haskell.lib.addBuildTools drv t)
            l;

        source-overrides = sourceOverrides;

        inherit name root;
      };
}
