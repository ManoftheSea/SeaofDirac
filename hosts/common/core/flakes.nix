{
  config,
  nixpkgs,
  ...
}: {
  environment.etc."nix/inputs/nixpkgs".source = nixpkgs;

  nix = {
    channel.enable = false;
    nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
    registry.nixpkgs.flake = nixpkgs;
    settings.experimental-features = ["nix-command" "flakes"];
    settings.nix-path = config.nix.nixPath;
  };
}
