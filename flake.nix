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
    deploy-rs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = function:
      nixpkgs.lib.genAttrs systems (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = import ./hosts inputs;

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
