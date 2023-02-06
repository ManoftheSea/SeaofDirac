{
  config,
  pkgs,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "derek@seaofdirac.org";
  };
}
