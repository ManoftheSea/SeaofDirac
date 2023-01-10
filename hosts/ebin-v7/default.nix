{ lib, pkgs, config, suites, ... }:

let
  placeholder = "";
in
{
  imports = suites.server;

  boot.loader.efi.canTouchEfiVariables = false;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
    };
    # TODO add data partition
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  networking = {
    hostName = "ebin-v7";
    useNetworkd = true;
    wireless.enable = false;
    useDHCP = false;
    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = [ "br0" ];
      allowedTCPPorts = [
        22
      ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.network = {
    enable = true;
    netdevs.br0.netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      eth0 = {
        matchConfig.Name = "eth0";
      };
      wan = {
        matchConfig.Name = "wan";
        networkConfig = {
          DHCP = "yes";
        };
      };
      lan = {
        matchConfig.Name = "lan*";
        networkConfig = {
          Bridge = "br0";
        };
      };
    };
  };

  environment = {
    noXlibs = true;
    systemPackages = with pkgs; [
      vim
      wget
    ];
  };

  hardware.enableRedistributableFirmware = true;

}
