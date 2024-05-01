{
  config,
  pkgs,
  ...
}: {
  users.users.solomon = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$pGtwwUj4Gzy47NMnlm.jK1$UffzcX0YWmVPXuuE27y64VNljY2zpNkhz9zek3iDT76";
    home = "/home/solomon";
    extraGroups =
      ["dialout" "video" "input"]
      ++ pkgs.lib.optional config.hardware.sane.enable "scanner"
      ++ pkgs.lib.optional config.hardware.pulseaudio.enable "audio";
  };
}
