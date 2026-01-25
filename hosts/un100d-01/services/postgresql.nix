_: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["hass"];
    ensureUsers = [
      {
        name = "hass";
        ensureDBOwnership = true;
      }
    ];
  };
}
# Netbox wants to set up a local postgres, but was configured to use remote
# Home Assisstant currently uses local database

