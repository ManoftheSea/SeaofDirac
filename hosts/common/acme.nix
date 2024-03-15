{
  config,
  pkgs,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      credentialsFile = config.sops.secrets.rfc2136_secret.path;
      dnsProvider = "rfc2136";
      email = "derek@seaofdirac.org";
    };
  };
}
