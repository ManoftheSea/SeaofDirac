{config, ...}: {
  # sops.secrets.sssd_envfile

  services.sssd = {
    enable = true;
    config = builtins.readFile ./sssd/config;
    environmentFile = config.sops.secrets.sssd_envfile.path;
  };
}
