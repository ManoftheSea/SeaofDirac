{
  networking = {
    firewall = {
      allowedTCPPorts = [
        22 # SSH
        5355 # LLMNR
      ];
      allowedUDPPorts = [
        5353 # mDNS
        5355 # LLMNR
      ];
    };
    hostName = "nickel";
    networkmanager.enable = true;
    nftables.enable = true;

    # wireless = {
    #   enable = true;
    #   extraConfig = ''
    #     ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
    #   '';
    # };
  };
}
