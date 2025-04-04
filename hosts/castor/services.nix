{config, ...}: {
  imports = [
    ./kea
  ];

  services.openssh.hostKeys = [
    {
      path = "/var/lib/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/ssh 0750 ${config.users.users.sshd.name} ${config.users.users.sshd.group}"
  ];
}
