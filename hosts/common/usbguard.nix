{
  services = {
    usbguard = {
      enable = true;
      IPCAllowedGroups = ["wheel"];
    };
  };
}
