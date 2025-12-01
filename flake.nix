{
  description = "Sea of Dirac setup";

  inputs = {
    ### Official NixOS Package Sources ###
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "deploy-rs/flake-compat";
      };
    };

    # Secrets management. TODO ./docs/secrets.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.nixpkgs-stable.follows = "nixpkgs";
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
          littlecreek.fastConnect = false;
          interserver-c01.fastConnect = false;
          interserver-s01.fastConnect = false;
        };
    };

    checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
