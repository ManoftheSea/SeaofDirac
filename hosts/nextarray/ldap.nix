let
  dbDomain = "seaofdirac.org";
  dbSuffix = "dc=seaofdirac,dc=org";

  ldapRootDN = "cn=admin,${dbSuffix}";
  ldapCertDomain = "nextarray.seaofdirac.org";
in
  {pkgs, ...}: {
    security.acme.certs."${ldapCertDomain}".postRun = ''
      systemctl restart openldap.service
    '';

    services.openldap = {
      enable = true;
      urlList = ["ldap://" "ldapi:///"];

      settings = {
        attrs = {
          olcLocalSSF = "256";
          #olcLogLevel = "ACL stats";
          olcLogLevel = "stats";

          # olcSaslRealm = "SEAOFDIRAC.ORG";
          # olcSaslSecProps = "noplain";
          olcSecurity = ["ssf=128" "update_ssf=128"];
          olcTLSCACertificateFile = "/run/credentials/openldap.service/full.pem";
          olcTLSCertificateFile = "/run/credentials/openldap.service/cert.pem";
          olcTLSCertificateKeyFile = "/run/credentials/openldap.service/key.pem";
          # olcTLScipherSuite = "AES128-GCM-SHA256";
          olcTLSCRLCheck = "none";
          olcTLSVerifyClient = "try";
          olcTLSProtocolMin = "3.4";

          olcAuthzRegexp = "{0}uid=([^,/]+),cn=seaofdirac\\.org,cn=[^,]+,cn=auth uid=$1,ou=People,dc=SeaofDirac,dc=org";
        };

        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            "${pkgs.openldap}/etc/schema/nis.ldif"
            ./ldap-schema/samba.ldif
            ./ldap-schema/kerberos.ldif
            ./ldap-schema/openssh-lpk.ldif
            ./ldap-schema/autofs.ldif
          ];
          # "olcDatabase={0}config".attrs.olcAccess = ["{0} to * by dn.exect=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break"];
          "olcDatabase={1}mdb".attrs = {
            objectClass = ["olcDatabaseConfig" "olcMdbConfig"];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/${dbSuffix}";
            olcSuffix = dbSuffix;
            olcRootDN = ldapRootDN;
            olcAccess = [
              ''
                {0}to dn.base="dc=seaofdirac,dc=org" by anonymous read
                  by * break''
              ''
                {1}to filter=(objectClass=pkiCA) attrs=@pkiCA
                  by anonymous read 
                  by * break''
              ''
                {2}to attrs=userPassword
                  by group/organizationalRole/roleOccupant="cn=admin,dc=seaofdirac,dc=org" write
                  by * auth''
              ''
                {3} to attrs=@posixAccount
                  by group/organizationalRole/roleOccupant="cn=admin,dc=seaofdirac,dc=org" write
                  by * break''
              ''
                {4}to dn.subtree="ou=Realms,dc=seaofdirac,dc=org"
                  by dn.exact="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by dn.exact="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" read
                  by group/organizationalRole/roleOccupant="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by group/organizationalRole/roleOccupant="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" read
                  by * none''
              ''
                {5}to attrs=objectClass val.regex=(krbPrincipalAux|krbTicketPolicyAux)
                  by dn.exact="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by group/organizationalRole/roleOccupant="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by * break''
              ''
                {6}to attrs=objectClass
                  by group/organizationalRole/roleOccupant="cn=admin,dc=seaofdirac,dc=org" write
                  by users read''
              ''
                {7}to attrs=krbLastSuccessfulAuth,krbLastFailedAuth,krbLoginFailedCount
                  by dn.exact="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by dn.exact="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" write
                  by group/organizationalRole/roleOccupant="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by group/organizationalRole/roleOccupant="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" write
                  by * none''
              ''
                {8}to attrs=@krbPrincipal,@krbPrincipalAux,@krbTicketPolicyAux
                  by dn.exact="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by dn.exact="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" read
                  by group/organizationalRole/roleOccupant="cn=kdc-admin,ou=Service,dc=seaofdirac,dc=org" write
                  by group/organizationalRole/roleOccupant="cn=kdc-read,ou=Service,dc=seaofdirac,dc=org" read
                  by * none''
              ''
                {9}to attrs=@person,@organizationalPerson,@inetOrgPerson,@ldapPublicKey
                  by self write
                  by group/organizationalRole/roleOccupant="cn=admin,dc=seaofdirac,dc=org" write
                  by users read
                  by * break''
              ''
                {20}to * by users read''
            ];
            olcDbIndex = [
              "objectClass eq"
              "cn pres,sub,eq"
              "uid pres,sub,eq"
              "sn pres,sub,eq"
              "displayName pres,sub,eq"
              "uidNumber eq"
              "gidNumber eq"
              "memberUid eq"
              "sambaSID eq"
              "sambaPrimaryGroupSID eq"
              "sambaDomainName eq"
              "krbPrincipalName eq"
              "krbPwdPolicyReference eq"
              "entryCSN,entryUUID eq"
            ];
          };
          "olcDatabase={2}monitor".attrs = {
            objectClass = ["olcDatabaseConfig" "olcMonitorConfig"];
            olcDatabase = "{2}monitor";
            olcAccess = ["{0}to * by group/organizationalRole/roleOccupant=\"cn=admin,dc=seaofdirac,dc=org\" read"];
          };
        };
      };
    };

    systemd.services.openldap = {
      serviceConfig.LoadCredential = [
        "full.pem:/var/lib/acme/${ldapCertDomain}/full.pem"
        "cert.pem:/var/lib/acme/${ldapCertDomain}/cert.pem"
        "key.pem:/var/lib/acme/${ldapCertDomain}/key.pem"
      ];
      after = ["acme-${ldapCertDomain}.service"];
      wants = ["acme-${ldapCertDomain}.service"];
    };
  }
