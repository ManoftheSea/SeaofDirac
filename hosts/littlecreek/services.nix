{
  security.acme.certs."littlecreek.seaofdirac.org" = {
    credentialsFile = config.sops.secrets."rfc2136.secret".path;
    dnsProvider = "rfc2136";
    email = "derek@seaofdirac.org";
    extraDomainNames = ["mta-sts.seaofdirac.org"];
  };

  services = {
    nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts."littlecreek.seaofdirac.org".enableACME = true;
    };

    openssh.hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    qemuGuest.enable = true;
  };
}
