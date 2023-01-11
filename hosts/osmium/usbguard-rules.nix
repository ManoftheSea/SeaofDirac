{ config, lib, pkgs, ... }:

{
  environment.etc."usbguard/rules.d/storage.conf".text = ''
    allow id 090c:1000 serial "0376522040001637" with-interface 08:06:50 
  '';
}
