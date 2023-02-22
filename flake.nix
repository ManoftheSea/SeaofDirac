{
  description = "Sea of Dirac setup";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-22.11";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixos";
    };

    # arion - for services deployed through docker?
  };

  outputs = {
    self,
    nixos,
    nixos-hardware,
    deploy-rs,
  } @ inputs: {
    formatter.x86_64-linux = nixos.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      aluminium = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/aluminium/default.nix
          nixos-hardware.nixosModules.framework-12th-gen-intel
          ./profiles/audio/pipewire.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/graphical/intel-gpu.nix
          ./profiles/hardware/efi.nix
          ./profiles/hardware/virt-manager.nix
          ./profiles/laptop.nix
          ./profiles/usbguard.nix
          ./users/derek.nix
          ./users/root.nix
        ];
      };

      ebin-v5 = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/ebin-v5/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/hardware/efi.nix
          ./profiles/impermanence.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./users/root.nix
        ];
      };
      ebin-v7 = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/ebin-v7/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/hardware/efi.nix
          ./profiles/impermanence.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./users/root.nix
        ];
      };
      littlecreek = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/littlecreek/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./profiles/acme.nix
          ./users/root.nix
        ];
      };
      nextarray = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/nextarray/default.nix
          ./profiles/core/base.nix
          ./profiles/core/flakes.nix
          ./profiles/server/base.nix
          ./profiles/server/harden-network.nix
          ./profiles/acme.nix
          ./users/root.nix
        ];
      };
    };

    # devshell = ./shell;

    # @TODO
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
          littlecreek.fastConnect = false;
          nextarray.fastConnect = false;
        };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
