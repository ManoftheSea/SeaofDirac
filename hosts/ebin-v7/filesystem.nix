{
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
