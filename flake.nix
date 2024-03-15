{
  description = "Sea of Dirac setup";

  inputs = {
    ### Official NixOS Package Sources ###
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Official hardware configurations
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    ### Utility repos ###

    # Deployment tool with magic rollback
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.utils.follows = "flake-utils";
    };

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative mail server with postfix and dovecot
    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "deploy-rs/utils";
    };

    # Secrets management. TODO ./docs/secrets.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    deploy-rs,
    disko,
    snm,
    sops-nix,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = function:
      nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});

  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    # client systems
    nixosConfigurations = {
      aluminium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/aluminium/default.nix
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-12th-gen-intel
          ./profiles/audio/pipewire.nix
          ./profiles/core/base.nix
          ./profiles/core/cache.nix
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
      nickel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/nickel/default.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./profiles/audio/pipewire.nix
          ./profiles/core/base.nix
          ./profiles/core/cache.nix
          ./profiles/core/flakes.nix
          ./profiles/graphical/intel-gpu.nix
          ./profiles/hardware/efi.nix
          ./profiles/hardware/virt-manager.nix
          ./profiles/impermanence.nix
          ./profiles/laptop.nix
          ./profiles/usbguard.nix
          ./users/derek.nix
          ./users/benjamin.nix
          ./users/root.nix
        ];
      };
      sodium = nixpkgs.lib.nixosSystem {
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
      crunchbits = nixpkgs.lib.nixosSystem {
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
      littlecreek = nixpkgs.lib.nixosSystem {
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
      technetium = nixpkgs.lib.nixosSystem {
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

    devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs;});

    # Deploy-rs uses "outputs.deploy" and "outputs.checks"
    deploy = {
      sshUser = "root";
      user = "root";
      fastConnect = true;

      # Create a deploy with the system profile for each nixosConfigurations
      nodes =
        nixpkgs.lib.recursiveUpdate (
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
