{nixos, ...}: {
  nix = {
    nixPath = ["nixpkgs=${nixos.outPath}"];
    registry.nixpkgs.flake = nixos;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
