{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "rfc2136";
      email = "derek@seaofdirac.org";
      environmentFile = config.sops.secrets.rfc2136_secret.path;
    };
  };
}
