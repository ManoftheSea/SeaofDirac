{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware = {
    opengl = {
      enable = lib.mkDefault true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };
}
