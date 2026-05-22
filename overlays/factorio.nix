_: _final: prev: let
  versionsJson = prev.writeText "factorio-2.0.43.json" ''
    {
      "x86_64-linux": {
        "alpha": {
          "stable": {
            "name": "factorio_linux_2.0.43.tar.xz",
            "needsAuth": true,
            "sha256": "971c293f46d2e021be762eb23c45c17746aa5b8ec74e30fef5f46fa32bb7e1aa",
            "tarDirectory": "x64",
            "url": "https://factorio.com/get-download/2.0.43/alpha/linux64",
            "version": "2.0.43"
          }
        },
        "headless": {
          "stable": {
            "name": "factorio-headless_linux_2.0.43.tar.xz",
            "needsAuth": false,
            "sha256": "sha256-vebhZzMMRDnOffOsUZ6kRRICWO9nbx9q0x0MKBbTruM=",
            "tarDirectory": "x64",
            "url": "https://factorio.com/get-download/2.0.43/headless/linux64",
            "version": "2.0.43"
          }
        }
      }
    }
  '';
in {
  factorio = prev.factorio.override {inherit versionsJson;};
  factorio-headless = prev.factorio-headless.override {inherit versionsJson;};
}
