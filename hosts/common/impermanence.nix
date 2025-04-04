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

  systemd.tmpfiles.settings = lib.mkMerge [
    (lib.mkIf config.networking.networkmanager.enable {
      nm-system-connections."/var/lib/NetworkManager/system-connections".d.mode = "0700";
    })
    (lib.mkIf config.services.openssh.enable {
      openssh."/var/lib/ssh".d = {
        inherit (config.users.users.sshd) group;
        user = config.users.users.sshd.name;
        mode = "0750";
      };
    })
  ];
}
