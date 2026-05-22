{pkgs, ...}: let
  python = pkgs.python3.override {
    self = python;
    packageOverrides = pyfinal: _pyprev: {
      netbox-acls = pyfinal.callPackage netbox-plugins/acls.nix {};
    };
  };
in {
  inherit python;
  netbox_4_4 = pkgs.netbox_4_4.override {
    python3 = python;
  };
}
