{config, ...}: {
  services.ddclient = {
    passwordFile = config.sops.secrets.ddclient.path;
    protocol = "nsupdate";
    server = "ns1.seaofdirac.org";
    usev4 = "disabled";
    usev6 = "webv6, webv6=ipify-ipv6";
    zone = "seaofdirac.org";
  };
}
