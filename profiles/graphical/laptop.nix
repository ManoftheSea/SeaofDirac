{ config, pkgs, ... }:

{
  # Reload ddcci module on monitor hotplug
  services.udev.extraRules =
    let
      reloadScript = pkgs.writeShellScriptBin "reload-ddcci" ''
        ${pkgs.kmod}/bin/modprobe -r ddcci && ${pkgs.kmod}/bin/modprobe ddcci
      '';
    in
    ''
      KERNEL=="card0", SUBSYSTEM=="drm", ACTION=="change", RUN+="${reloadScript}/bin/reload-ddcci"
    '';
}
