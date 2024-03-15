{
  config,
  pkgs,
  ...
}: {
  # Maybe add some test to see if NetworkManager is being used?
  environment.etc."NetworkManager/system-connections".source = "/var/lib/NetworkManager/system-connections/";

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0700 /var/lib/NetworkManager/system-connections
    mkdir -pm 0755 /var/lib/ssh
  '';
}
