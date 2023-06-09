{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./services.nix
    ./network.nix
  ];

  boot.kernelModules = ["coretemp"];

  environment = {
    etc."sysconfig/lm_sensors".text = ''
      HWMON_MODULES="coretemp"
    '';

    noXlibs = false;

    systemPackages = with pkgs; [
      lm_sensors
      powertop
      vim
      wget
    ];
  };

  hardware.enableRedistributableFirmware = true;

  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.powertop.enable = true;

  security.acme.certs."pollux.seaofdirac.org".extraDomainNames = ["nextcloud.seaofdirac.org"];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';

  system.stateVersion = "23.05";
}
