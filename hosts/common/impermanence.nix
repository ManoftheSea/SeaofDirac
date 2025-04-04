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

  systemd.tmpfiles.rules = [
    (lib.mkIf config.networking.networkmanager.enable "d /var/lib/NetworkManager/system-connections 0700")
    (lib.mkIf config.services.openssh.enable "d /var/lib/ssh 0750 ${config.users.users.sshd.name} ${config.users.users.sshd.group}")
  ];
}
