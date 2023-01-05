{
  description = "Sea of Dirac setup";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home-manager";
    digga.inputs.deploy.follows = "deploy";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    nixos-generators.url = "github:nix-community/nixos-generators";

    # arion - for services deployed through docker?

  };

  outputs = { 
    self, 
    nixos,
    nixos-hardware,
    digga,
    home-manager,
    agenix,
    deploy,
    nixos-generators
  } @ inputs:

    digga.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      channels.nixos = {
#        imports = [ (digga.lib.importOverlays ./overlays) ];
	overlays = [
#          agenix.overlays.default
#	  ./pkgs/default.nix
        ];
      };

      nixos = {
        hostDefaults = {
	  system = "x86_64-linux";
	  channelName = "nixos";
	  imports = [ (digga.lib.importExportableModules ./modules) ];
	  modules = [
#	    agenix.nixosModules.age
            ./users/root.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	    }
#	    arion.nixosModules.arion
	  ];
	};

        imports = [ (digga.lib.importHosts ./hosts) ];

	importables = rec {
	  profiles = digga.lib.rakeLeaves ./profiles;
	  suites = with builtins; let explodeAttrs = set: map (a: getAttr a set) (attrNames set); in
	  with profiles; rec {
            base = (explodeAttrs core) ++ [ vars ];
	    server = base ++ [ profiles.server profiles.harden ];
#	    desktop = base ++ [ audio ] ++ (explodeAddrs graphical) ++ (explodeAttrs pc) ++ (explodeAttrs hardware) ++ (explodeAttrs develop);
	    laptop = base ++ [ profiles.laptop ];
	  };
	};

	hosts = {
	  aluminium.modules = [ nixos-hardware.nixosModules.framework-12th-gen-intel ./users/derek.nix ];
	  ebin-v5.system = "aarch64-linux";
	  ebin-v7.system = "aarch64-linux";
	};
      };

#      devshell = ./shell;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        ebin-v5 = {
	  profiles.system.sshUser = "root";
	};
	ebin-v7 = {
	  profiles.system.sshUser = "root";
	};
      };

    };
}
