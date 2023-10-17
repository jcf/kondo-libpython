{
  description = "kondo-libpython";

  inputs = {
    devenv.url =
      "github:cachix/devenv/9ba9e3b908a12ddc6c43f88c52f2bf3c1d1e82c1";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, devenv, nixpkgs-python }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ({ pkgs, ... }: {
              packages = with pkgs; [
                # Functions and immutability
                babashka
                clj-kondo
                clojure
                clojure-lsp

                # Python dependencies
                arrow-cpp
                cmake
              ];

              # ----------------------------------------------------------------
              # Python

              languages.python.enable = true;
              languages.python.poetry.enable = true;
              languages.python.poetry.activate.enable = true;
              languages.python.poetry.install.enable = true;

              # pyarrow doesn't work with Python 3.12, yet.
              #
              # https://github.com/apache/arrow/issues/34757#issuecomment-1750072067
              languages.python.version = "3.11";
            })
          ];
        };
      });
}
