{
  config,
  pkgs,
  ...
}: {
  users.users.benjamin = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$4NrdHmxqFppno3lIQ/RPR0$b3kYL4d0aBIMV.K0IQQX4QEgjf4a85yFzUFAwlv5r6B";
    home = "/home/benjamin";
    extraGroups =
      ["dialout" "video" "input"]
      ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ pkgs.lib.optional config.hardware.sane.enable "scanner"
      ++ pkgs.lib.optional config.hardware.pulseaudio.enable "audio";
  };
}
