{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./network.nix
  ];

  environment = {
    noXlibs = true;
    systemPackages = with pkgs; [
      vim
      wget
    ];
  };

  hardware.enableRedistributableFirmware = true;
}
