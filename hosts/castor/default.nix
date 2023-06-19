{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./network.nix
    ./services.nix
  ];

  boot.kernelModules = ["coretemp"];

  environment = {
    etc."sysconfig/lm_sensors".text = ''
      HWMON_MODULES="coretemp"
    '';
    # noXlibs = true;
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

  services.openssh = {
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  system.activationScripts.persistent-directories = ''
    mkdir -pm 0755 /var/lib/ssh
  '';
}
