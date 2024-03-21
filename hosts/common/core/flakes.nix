{nixpkgs, ...}: {
  environment.etc."nix/path/nixpkgs".source = nixpkgs;

  nix = {
    channel.enable = false;
    nixPath = ["/etc/nix/path"];
    registry.nixpkgs.flake = nixpkgs;
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
