{nixos, ...}: {
  nix.registry.nixpkgs.flake = nixos;
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
