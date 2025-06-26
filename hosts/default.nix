{
  self,
  disko,
  nixos-hardware,
  nixpkgs,
  snm,
  sops-nix,
  ...
} @ inputs: let
  inherit (nixpkgs) lib;
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
      #./common/core/cache.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/hardware/virt-manager.nix
      ./common/impermanence.nix
      ./common/laptop.nix
      ./common/usbguard.nix
      ../users/derek.nix
      ../users/root.nix
    ];
  };
  nickel = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./nickel/default.nix
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      {nixpkgs.overlays = builtins.attrValues self.overlays;}
      ./common/audio/pipewire.nix
      ./common/core/base.nix
      #./common/core/cache.nix
      ./common/core/flakes.nix
      ./common/graphical/intel-gpu.nix
      ./common/hardware/efi.nix
      ./common/hardware/virt-manager.nix
      ./common/impermanence.nix
      ./common/laptop.nix
      ./common/usbguard.nix
      ../users/root.nix
      ../users/benjamin.nix
      ../users/solomon.nix
    ];
  };
  tin = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      ./tin/default.nix
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      {nixpkgs.overlays = builtins.attrValues self.overlays;}
      ./common/audio/pipewire.nix
      ./common/core/base.nix
      #./common/core/cache.nix
      ./common/core/flakes.nix
      ./common/graphical/intel-gpu.nix
      ./common/hardware/efi.nix
      ./common/hardware/virt-manager.nix
      ./common/impermanence.nix
      ./common/laptop.nix
      ./common/usbguard.nix
      ../users/root.nix
      ../users/benjamin.nix
      ../users/solomon.nix
    ];
  };

  # server systems
  crunchbits = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./crunchbits/default.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/core/no-nixpkgs.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/impermanence.nix
      ../users/root.nix
    ];
  };
  castor = lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules = [
      ./castor
      sops-nix.nixosModules.sops
      disko.nixosModules.disko
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/impermanence.nix
      ../users/root.nix
    ];
  };
  littlecreek = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      snm.nixosModule
      sops-nix.nixosModules.sops
      ./littlecreek/default.nix
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/core/no-nixpkgs.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/impermanence.nix
      ./common/acme.nix
      ../users/root.nix
    ];
  };
  pollux = lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = inputs;
    modules = [
      ./pollux
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/base.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/impermanence.nix
      ../users/root.nix
    ];
  };
  technetium = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./technetium/default.nix
      {nixpkgs.overlays = builtins.attrValues self.overlays;}
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/certificates.nix
      ./common/impermanence.nix
      ./common/usbguard.nix
      ../users/root.nix
    ];
  };
  un100d-01 = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./un100d-01
      {nixpkgs.overlays = builtins.attrValues self.overlays;}
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/certificates.nix
      ./common/impermanence.nix
      ./common/usbguard.nix
      ../users/root.nix
    ];
  };
  un100d-02 = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      disko.nixosModules.disko
      sops-nix.nixosModules.sops
      ./un100d-01
      {nixpkgs.overlays = builtins.attrValues self.overlays;}
      ./common/core/base.nix
      ./common/core/flakes.nix
      ./common/hardware/efi.nix
      ./common/server/harden-network.nix
      ./common/server/security.nix
      ./common/acme.nix
      ./common/certificates.nix
      ./common/impermanence.nix
      ./common/usbguard.nix
      ../users/root.nix
    ];
  };
}
