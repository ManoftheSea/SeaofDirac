{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./filesystem.nix
    ./mailserver.nix
    ./named.nix
    ./network.nix
    ./services.nix
  ];

  environment = {
    etc."machine-id".text = "5ad95e997a0f413f8770de368bb106ce";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        ndisc6
        tcpdump
        vim
        wget
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
