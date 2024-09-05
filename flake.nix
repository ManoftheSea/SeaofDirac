{
  description = "Sea of Dirac setup";

  inputs = {
    ### Official NixOS Package Sources ###
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-24_05.follows = "nixpkgs";
        utils.follows = "deploy-rs/utils";
        flake-compat.follows = "deploy-rs/flake-compat";
      };
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
    deploy-rs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = function:
      nixpkgs.lib.genAttrs systems function;
  in {
    devShells = forAllSystems (system: import ./shell.nix (inputs // {inherit system;}));
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixosConfigurations = import ./hosts inputs;
    nixosModules = import ./modules inputs;
    overlays = import ./overlays/factorio.nix {};
    packages.x86_64-linux.appliance_1 = let
      inherit (self.nixosConfigurations.usb) config;
      inherit (nixpkgs.legacyPackages.x86_64-linux) pkgs;
    in
      pkgs.runCommand "update-${config.system.image.version}" {
        nativeBuildInputs = [pkgs.xz];
      } ''
        mkdir -p $out
        xz -1 -cz ${config.system.build.uki}/${config.system.boot.loader.ukiFile} \
          > $out/${config.system.boot.loader.ukiFile}.xz
        xz -1 -cz ${config.system.build.image}/${config.boot.uki.name}_${config.system.image.version}.store.raw \
          > $out/store_${config.system.image.version}.img.xz
      '';

    # Deploy-rs uses "outputs.deploy" and "outputs.checks"
    deploy = {
      sshUser = "root";
      user = "root";
      fastConnect = true;

      # Create a deploy with the system profile for each nixosConfigurations
      nodes =
        lib.recursiveUpdate (
          builtins.mapAttrs (hostname: nixosConfig: {
            inherit hostname;
            profiles.system.path = deploy-rs.lib.${nixosConfig.config.nixpkgs.system}.activate.nixos nixosConfig;
          })
          (lib.filterAttrs (n: _v: n != "aluminium") self.nixosConfigurations)
        )
        {
          crunchbits.fastConnect = false;
          littlecreek.fastConnect = false;
        };
    };

    checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
