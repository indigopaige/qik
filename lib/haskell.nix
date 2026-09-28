{ system
, pkgs
, ...
}:

rec {
  defaultGhcv = "9124";
  mk          = { sourceOverrides ? {}
                , ghcv ? defaultGhcv
                , tool ? (_: [])
                , libs ? (_: [])
                , name
                , root
                , ...
                }:
                  let ghcr = "ghc${ghcv}";
                      ghcp = pkgs.haskell.packages.${ghcr};
                      ghcc = pkgs.haskell.compiler.${ghcr};
                      t    = [ ghcc ghcp.cabal-install pkgs.hpack ] ++ (tool pkgs);
                      l    = libs pkgs;
                  in ghcp.developPackage
                    { modifier = drv:
                        pkgs.haskell.lib.addExtraLibraries
                          (pkgs.haskell.lib.addBuildTools drv t) l;
                      source-overrides = sourceOverrides;
                      inherit name root;
                    };
}
