{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./filesystem.nix
    ./hardware.nix
    ./services.nix
  ];

  networking.hostName = "sodium";

  environment = {
    etc."machine-id".text = "72835a28cc8649f28cdcda55fb784bab";
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        file
        git
        gptfdisk
        home-manager
        less
        minicom
        pciutils
        perl
        psmisc
        rsync
        strace
        tmux
        usbutils
        wget
        ;
    };
  };

  programs = {
    dconf.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    sway.enable = true;
  };

  security.polkit.enable = true;

  zramSwap.enable = true;
  # zramSwap.memoryPercent = 50;
}
