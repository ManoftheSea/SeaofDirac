{nixpkgs, ...}: {
  nix = {
    channel.enable = false;
    nixPath = ["nixpkgs=${nixpkgs.outPath}"];
    registry.nixpkgs.flake = nixpkgs;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
