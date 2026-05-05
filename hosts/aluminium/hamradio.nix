_: {
  services.udev.extraRules = ''
    # All-in-One-Cable for ham radio
    SUBSYSTEM!="sound", GOTO="ham_audio_end"
    ACTION!="add", GOTO="ham_audio_end"
    ATTRS{serial}=="87dc4e93", ATTR{id}="AIOC_YELLOW"
    ATTRS{serial}=="8e8d7a43", ATTR{id}="AIOC_BLACK"
    LABEL="ham_audio_end"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="7388", GROUP="audio"
  '';
}
