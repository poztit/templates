{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = nixpkgs.lib;

      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium
          pgfplots
          tikzmark
          latexmk
          biblatex;
      };

      src = lib.cleanSource ./.;
    in
    {
      formatter = pkgs.nixpkgs-fmt;

      devShells.default = pkgs.mkShell {
        name = "research-paper";
        packages = with pkgs; [
          (python312.withPackages (ps: with ps; [ pygments ]))
          tex
          bibtool
          bibtex-tidy
          latexindent
        ];
      };

      packages.default = pkgs.stdenv.mkDerivation {
        name = "research-paper";
        inherit src;
        buildInputs = [ tex ];
        buildPhase = ''
          latexmk -pdf -interaction=nonstopmode article
        '';
        installPhase = ''
          mkdir -p $out
          cp article.pdf $out/
        '';
      };

      packages.diff = pkgs.stdenv.mkDerivation {
        name = "latex-diff";
        src = ./.;
        buildInputs = with pkgs; [
          tex
          bibtool
          git
        ];
        buildPhase = ''
          git latexdiff --run-bibtex --main article.tex origin/master
        '';
        installPhase = ''
          mkdir -p $out
          cp diff.pdf $out/
        '';
      };
    });
}
