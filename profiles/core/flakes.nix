{nixos, ...}: {
  nix = {
    channel.enable = false;
    nixPath = ["nixpkgs=${nixos.outPath}"];
    registry.nixpkgs.flake = nixos;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
