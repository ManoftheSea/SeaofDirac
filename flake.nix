{
  description = "Sea of Dirac setup";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-22.11";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    digga = {
      url = "github:divnix/digga";
      inputs = {
        nixpkgs.follows = "nixos";
        nixlib.follows = "nixos";
        deploy.follows = "deploy-rs";
      };
    };

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
    digga,
    deploy-rs,
  } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      supportedSystems = ["x86_64-linux" "aarch64-linux"];
      formatter.x86_64-linux = nixos.legacyPackages.x86_64-linux.alejandra;

      channels.nixos = {
        # imports = [ (digga.lib.importOverlays ./overlays) ];
        overlays = [
          # agenix.overlays.default
          # ./pkgs/default.nix
        ];
      };

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          #imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            # agenix.nixosModules.age
            ./users/root.nix
            # arion.nixosModules.arion
          ];
        };

        imports = [(digga.lib.importHosts ./hosts)];

        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles;
          suites = with builtins; let
            explodeAttrs = set: map (a: getAttr a set) (attrNames set);
          in
            with profiles; rec {
              base = explodeAttrs core ++ [profiles.hardware.efi];
              server = base ++ (explodeAttrs profiles.server);
              vps = explodeAttrs core ++ (explodeAttrs profiles.server);
              # desktop = base ++ [ audio ] ++ (explodeAddrs graphical) ++ (explodeAttrs pc) ++ (explodeAttrs hardware) ++ (explodeAttrs develop);
              laptop = base ++ [profiles.laptop];
            };
        };

        hosts = {
          aluminium.modules = [nixos-hardware.nixosModules.framework-12th-gen-intel ./users/derek.nix];
          osmium.modules = [nixos-hardware.nixosModules.framework-12th-gen-intel];
          ebin-v5.system = "aarch64-linux";
          ebin-v7.system = "aarch64-linux";
        };
      };

      # devshell = ./shell;

      # homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        ebin-v5 = {
          profiles.system.sshUser = "root";
        };
        ebin-v7 = {
          profiles.system.sshUser = "root";
        };
        littlecreek = {
          profiles.system.sshUser = "root";
        };
      };
    };
}
