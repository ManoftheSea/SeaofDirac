{config, ...}: {
  services.zwave-js = {
    inherit (config.services.home-assistant) enable;
    secretsConfigFile = config.sops.secrets."zwave_keys".path;
    serialPort = "/dev/serial/by-id/usb-Silicon_Labs_HubZ_Smart_Home_Controller_C130257C-if00-port0";
  };

  sops.secrets."zwave_keys" = {};
}
