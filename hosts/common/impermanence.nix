{
  config,
  lib,
  ...
}: {
  environment.etc = lib.mkIf config.networking.networkmanager.enable {
    "NetworkManager/system-connections".source = "/var/lib/NetworkManager/system-connections/";
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.activationScripts = lib.mkMerge [
    (lib.mkIf config.networking.networkmanager.enable {
      persist-nm = ''
        mkdir -pm 0700 /var/lib/NetworkManager/system-connections
      '';
    })
    (lib.mkIf config.services.openssh.enable {
      persist-sshkey = ''
        mkdir -pm 0755 /var/lib/ssh
      '';
    })
  ];
}
