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
        deadnix
        deploy-rs
        git
        home-manager
        lefthook
        nix
        sops
        ssh-to-age
        statix
        ;
    };
  };
  kvm = let
    qemu-efi = pkgs.writeShellApplication {
      name = "qemu-efi";
      runtimeInputs = [pkgs.qemu_kvm];
      text = ''
        qemu-system-x86_64 -smp 2 -m 2048 \
          -machine q35,accel=kvm -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          -snapshot \
          -serial stdio "$@"
      '';
    };
  in
    pkgs.mkShellNoCC {
      packages = [qemu-efi];
    };
}
