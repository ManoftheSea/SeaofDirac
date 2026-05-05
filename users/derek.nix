{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}: {
  users.users.derek = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$SWiLnOMuyAAe7yblyKC2w0$5lroMTYzWPKHTylTTPDUtlgGnEGB0KPX0/e9ja6vV7B";
    home = "/home/derek";
    extraGroups =
      [
        "audio"
        "dialout"
        "input"
        "video"
        "wheel"
      ]
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      # ++ lib.optional config.programs.light.enable "video"
      ++ lib.optional config.hardware.sane.enable "scanner";
  };
}
