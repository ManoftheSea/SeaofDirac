{
  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" "noexec" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix_store";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "ext4";
      options = [ "noexec" ];
    };
    "/efi" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [ "noexec" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
