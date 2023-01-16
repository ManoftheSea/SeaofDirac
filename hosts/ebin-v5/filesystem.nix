{
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/Nixos";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
    };
    # TODO add data partition
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

}
