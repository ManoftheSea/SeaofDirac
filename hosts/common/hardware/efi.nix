{
  config,
  lib,
  ...
}: {
  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    systemd-boot.editor = lib.mkDefault true;
    efi = {
      canTouchEfiVariables = lib.mkDefault true;
      efiSysMountPoint = lib.mkDefault "/efi";
    };
  };
}
