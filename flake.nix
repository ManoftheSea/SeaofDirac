{
  description = "Sea of Dirac setup";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

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
    home,
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
	    home.nixosModules.home-manager
#	    arion.nixosModules.arion
	  ];
	};

        imports = [ (digga.lib.importHosts ./hosts) ];

	importables = rec {
	  profiles = digga.lib.rakeLeaves ./profiles;
	  suites = with builtins; let explodeAttrs = set: map (a: getAttr a set) (attrNames set); in
	  with profiles; rec {
#	    base = (explodeAttrs core) ++ [ vars ];
            base = [ vars ];
	    server = base ++ [ profiles.server profiles.harden ];
#	    desktop = base ++ [ audio ] ++ (explodeAddrs graphical) ++ (explodeAttrs pc) ++ (explodeAttrs hardware) ++ (explodeAttrs develop);
	    laptop = base ++ [ profiles.laptop ];
	  };
	};

	hosts = {
	  aluminium.modules = [ nixos-hardware.nixosModules.framework-12th-gen-intel ];
	  ebin-v5.system = "aarch64-linux";
	  ebin-v7.system = "aarch64-linux";
	};
      };

      devshell = ./shell;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfiguraions {
        ebin-v5 = {
	  profiles.system.sshUser = "root";
	};
	ebin-v7 = {
	  profiles.system.sshUser = "root";
	};
      };

    };
}
