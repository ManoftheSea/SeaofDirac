_: {
  modifications = _final: prev: let
    versionsJson = prev.writeText "factorio-2.0.10.json" ''
      {
        "x86_64-linux": {
          "alpha": {
            "stable": {
              "name": "factorio_linux_2.0.10.tar.xz",
              "needsAuth": true,
              "sha256": "16rrbia0iv9lp5rbfwnqkc1nwcpacdladppyb9fyz59g272qyl07",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/2.0.10/alpha/linux64",
              "version": "2.0.10"
            }
          },
          "headless": {
            "stable": {
              "name": "factorio-headless_linux_2.0.10.tar.xz",
              "needsAuth": false,
              "sha256": "1x13ihgywn9i6hkyfz5zly7rky1sb5yssfz3llc54wbgz89d4z9d",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/2.0.10/headless/linux64",
              "version": "2.0.10"
            }
          }
        }
      }
    '';
  in {
    factorio = prev.factorio.override {inherit versionsJson;};
    factorio-headless = prev.factorio-headless.override {inherit versionsJson;};
  };
}
