#ebin v7
{pkgs, ...}: {
  imports = [
    ./disko.nix
    ./network.nix
    ./services
  ];

  environment = {
    etc."sysconfig/lm_sensors".text = ''
      HWMON_MODULES="coretemp"
    '';

    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        bind
        lm_sensors
        powertop
        tcpdump
        vim
        wget
        ;
    };
  };

  hardware.enableRedistributableFirmware = true;

  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.powertop.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  };
}
