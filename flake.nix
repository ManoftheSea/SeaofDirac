{
  description = "Sea of Dirac setup";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos";
      # inputs.utils.follows = "flake-utils";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixos";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.05";
      inputs.nixpkgs.follows = "nixos";
      inputs.utils.follows = "deploy-rs/utils";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos";
      inputs.nixpkgs-stable.follows = "nixos";
    };
  };

  outputs = {
    self,
    nixos,
    nixos-hardware,
    deploy-rs,
    disko,
    snm,
    sops-nix,
  } @ inputs: {
    formatter.x86_64-linux = nixos.legacyPackages.x86_64-linux.alejandra;

    # client systems
    nixosConfigurations = {
      aluminium = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/aluminium/default.nix
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-12th-gen-intel
          ./profiles/audio/pipewire.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/graphical/intel-gpu.nix
          ./profiles/hardware/efi.nix
          ./profiles/hardware/virt-manager.nix
          ./profiles/impermanence.nix
          ./profiles/laptop.nix
          ./profiles/usbguard.nix
          ./users/derek.nix
          ./users/root.nix
        ];
      };
      nickel = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/nickel/default.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./profiles/audio/pipewire.nix
          ./profiles/auth/sssd.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/graphical/intel-gpu.nix
          ./profiles/hardware/efi.nix
          ./profiles/hardware/virt-manager.nix
          ./profiles/impermanence.nix
          ./profiles/laptop.nix
          ./profiles/usbguard.nix
          ./users/derek.nix
          ./users/root.nix
        ];
      };
      sodium = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/sodium/default.nix
          ./profiles/audio/pipewire.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/graphical/intel-gpu.nix
          ./profiles/hardware/efi.nix
          ./profiles/impermanence.nix
          ./users/benjamin.nix
          ./users/derek.nix
          ./users/root.nix
        ];
      };

      # server systems
      crunchbits = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/crunchbits/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./profiles/server/security.nix
          ./profiles/acme.nix
          ./users/root.nix
        ];
      };
      littlecreek = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          snm.nixosModule
          sops-nix.nixosModules.sops
          ./hosts/littlecreek/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./profiles/server/security.nix
          ./profiles/acme.nix
          ./users/root.nix
        ];
      };
      technetium = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/technetium/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/hardware/efi.nix
          ./profiles/server/harden-network.nix
          ./profiles/server/security.nix
          ./profiles/acme.nix
          ./profiles/certificates.nix
          ./profiles/usbguard.nix
          ./users/root.nix
        ];
      };
    };

    # devshell = ./shell;

    deploy = {
      sshUser = "root";
      user = "root";
      fastConnect = true;

      # Create a deploy with the system profile for each nixosConfigurations
      nodes =
        nixos.lib.recursiveUpdate (
          builtins.mapAttrs (hostname: nixosConfig: {
            inherit hostname;
            profiles.system.path = deploy-rs.lib.${nixosConfig.config.nixpkgs.system}.activate.nixos nixosConfig;
          })
          self.nixosConfigurations
        )
        {
          crunchbits.fastConnect = false;
          littlecreek.fastConnect = false;
        };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
