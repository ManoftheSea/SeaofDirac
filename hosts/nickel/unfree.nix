{lib, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "factorio-alpha"
      "steam"
      "steam-original"
      "steam-run"
    ];
}
