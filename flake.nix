{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, devshell, ... }@inputs:
  flake-parts.lib.mkFlake { inherit inputs; } (
    { ... }:
    {
      systems = [ "x86_64-linux" ];
      imports = [
        devshell.flakeModule
      ];
      perSystem = { pkgs, ... }: let
        stickerpicker = with pkgs.python312Packages; buildPythonPackage rec {
          pname = "stickerpicker";
          version = "1.1";
          format = "setuptools";
          src = fetchGit {
            url = "https://github.com/maunium/stickerpicker";
            rev = "3366dbc5002046be058a71e7ed310811a122c081";
          };
          buildInputs = with pkgs.python312Packages; [
          ];
        };
      in
      {
        devshells.default = {
          packages = [
            (pkgs.python312.withPackages (python-pkgs: with pkgs.python312Packages; [
              telethon
              aiohttp
              pillow
              stickerpicker
            ]))
          ];
        };
      };
    }
  );  
}
