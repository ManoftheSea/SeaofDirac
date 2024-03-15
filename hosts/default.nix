{
  disko,
  nixos-hardware,
  nixpkgs,
  snm,
  sops-nix,
  ...
} @ inputs: let
  lib = nixpkgs.lib;
in {
  aluminium = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./aluminium/default.nix
      disko.nixosModules.disko
      nixos-hardware.nixosModules.framework-12th-gen-intel
      ./common/audio/pipewire.nix
      ./common/core/base.nix
      ./common/core/cache.nix
      ./common/core/flakes.nix
      ./common/graphical/intel-gpu.nix
      ./common/hardware/efi.nix
      ./common/hardware/virt-manager.nix
      ./common/impermanence.nix
      ./common/laptop.nix
      ./common/usbguard.nix
      ../users/derek.nix
      ../users/root.nix
    ];
  };
  nickel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./nickel/default.nix
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./common/audio/pipewire.nix
      ./common/core/base.nix
      ./common/core/cache.nix
      ./common/core/flakes.nix
      ./common/graphical/intel-gpu.nix
      ./common/hardware/efi.nix
      ./common/hardware/virt-manager.nix
      ./common/impermanence.nix
      ./common/laptop.nix
      ./common/usbguard.nix
      ../users/derek.nix
      ../users/benjamin.nix
      ../users/root.nix
    ];
  };
  sodium = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./sodium/default.nix
      ./common/audio/pipewire.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/graphical/intel-gpu.nix
      ./common/hardware/efi.nix
      ./common/impermanence.nix
      ../users/benjamin.nix
      ../users/derek.nix
      ../users/root.nix
    ];
  };

  # server systems
  crunchbits = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./crunchbits/default.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ../users/root.nix
    ];
  };
  littlecreek = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      snm.nixosModule
      sops-nix.nixosModules.sops
      ./littlecreek/default.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ../users/root.nix
    ];
  };
  technetium = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./technetium/default.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/certificates.nix
      ./common/usbguard.nix
      ../users/root.nix
    ];
  };
}
