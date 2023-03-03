{
  mailserver = {
    enable = true;
    fqdn = "littlecreek.seaofdirac.org";
    domains = ["seaofdirac.org"];
    loginAccounts = {
      "derek@seaofdirac.org" = {
        hashedPasswordFile = "/etc/passwd";
        aliases = [
          "root@seaofdirac.org"
          "security@seaofdirac.org"
        ];
      };
    };
  };
}
