{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./services.nix
    ./network.nix
  ];

  boot.kernelModules = ["coretemp"];
  # boot.initrd = {
  #   availableKernelModules = ["lz4" "lz4_compress" "z3fold"];
  #   kernelModules = ["lz4" "lz4_compress" "z3fold"];
  #   preDeviceCommands = ''
  #     printf lz4 > /sys/module/zswap/parameters/compressor
  #     printf z3fold > /sys/module/zswap/parameters/zpool
  #   '';
  # };

  # boot.kernelParams = ["zswap.enabled=1" "zswap.compressor=lz4"];
  # boot.kernelPackages = pkgs.linuxPackages.extend (lib.const (super: {
  #   kernel = super.kernel.overrideDerivation (drv: {
  #     nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [pkgs.lz4];
  #   });
  # }));

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
