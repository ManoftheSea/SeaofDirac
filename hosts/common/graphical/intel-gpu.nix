{
  pkgs,
  lib,
  ...
}: {
  hardware = {
    opengl = {
      enable = lib.mkDefault true;
      extraPackages = builtins.attrValues {
        inherit
          (pkgs)
          vaapiIntel
          libvdpau-va-gl
          intel-media-driver
          ;
      };
    };
  };
}
