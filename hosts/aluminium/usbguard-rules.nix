{ config, ... }:

{
  environment.etc = {
    "usbguard/rules.d/framework.conf".text = ''
      # Hardwired equipment
      allow id 0bda:5634 serial "200901010001" with-interface { 0e:01:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 } with-connect-type "hardwired"  # camera
      allow id 27c6:609c with-connect-type "hardwired"  # fingerprint reader
      allow id 8087:0032 with-connect-type "hardwired"  # AX210 bluetooth

      # Framework cards
      allow id 1d6b:0003 serial "0000:00:14.0" hash "prM+Jby/bFHCn2lNjQdAMbgc6tse3xVx+hZwjOPHSdQ=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" # USB C framework cards connection
      allow id 090c:3350 serial "AA00000000015055" name "USB DISK" hash "Evsyyqu0HmcF8bvbphuzdMbkOCr4AqrBdp+zu7smY2w=" with-interface 08:06:50 with-connect-type "hotplug" # uSD reader
      allow id 32ac:0002 serial "11AD1D0005D63E0428280B00" hash "RzKzUk2WrpbvuQbGjG4W0Cnw8TCXJD/27pYPb2RWQvU=" with-interface { 11:00:00 03:00:00 } with-connect-type "hotplug" # HDMI card
    '';

    "usbguard/rules.d/storage.conf".text = ''
      allow id 090c:1000 serial "0376522040001637" with-interface 08:06:50 
    '';
    "usbguard/rules.d/serial.conf".text = ''
      allow id 0403:6015 serial "DT0307Z0" # Serial Port
    '';
  };
}

