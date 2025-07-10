{
  description = "A collection of nix flake templates";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils, ... }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      templates.article = {
        path = ./article;
        description = "Research paper template";
      };
      defaultTemplate = self.templates.article;
      formatter = pkgs.nixpkgs-fmt;
    });
}
