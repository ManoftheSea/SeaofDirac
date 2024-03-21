# Shell for bootstrapping, modifying the config, and managing secrets
{
  nixpkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    nixpkgs,
  system ? builtins.currentSystem,
  ...
}: let
  pkgs = import nixpkgs {inherit system;};
in {
  default = pkgs.mkShellNoCC {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    packages = builtins.attrValues {
      inherit
        (pkgs)
        age
        deploy-rs
        git
        home-manager
        nix
        sops
        ssh-to-age
        ;
    };
  };
}
