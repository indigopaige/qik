{
  inputs =
    { flake-utils.url = "github:numtide/flake-utils";
          nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      crane.url       = "github:ipetkov/crane";
      
    };

  outputs =
    inputs@{ flake-utils
    , nixpkgs
    , self
    , ...
    }: flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs =    import nixpkgs {
              inherit system;

              config = {
                problems.handlers = {
                  eigen.broken = "ignore";
                };
              };
            };

            load = l: import l       { inherit system pkgs nixpkgs inputs; };
        in
          { lib.haskell = load ./lib/haskell.nix;
            lib.rust    = load ./lib.rust.nix;
          });
}
