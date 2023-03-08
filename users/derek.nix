{
  config,
  pkgs,
  ...
}: {
  users.users.derek = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$SWiLnOMuyAAe7yblyKC2w0$5lroMTYzWPKHTylTTPDUtlgGnEGB0KPX0/e9ja6vV7B";
    home = "/home/derek";
    extraGroups =
      ["wheel" "dialout" "video" "input"]
      ++ pkgs.lib.optional config.virtualisation.libvirtd.enable "libvirtd"
      ++ pkgs.lib.optional config.virtualisation.docker.enable "docker"
      ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
      # ++ pkgs.lib.optional config.programs.light.enable "video"
      ++ pkgs.lib.optional config.hardware.sane.enable "scanner"
      ++ pkgs.lib.optional config.hardware.pulseaudio.enable "audio";
  };
}
