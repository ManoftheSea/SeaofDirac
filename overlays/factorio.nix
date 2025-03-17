_: {
  modifications = _final: prev: let
    versionsJson = prev.writeText "factorio-2.0.32.json" ''
      {
        "x86_64-linux": {
          "alpha": {
            "stable": {
              "name": "factorio_linux_2.0.32.tar.xz",
              "needsAuth": true,
              "sha256": "07v1rw2bh5sgscmby12j29y3pw9nmpn3cbbl5gh10zdydfc38d2c",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/2.0.32/alpha/linux64",
              "version": "2.0.32"
            }
          },
          "headless": {
            "stable": {
              "name": "factorio-headless_linux_2.0.32.tar.xz",
              "needsAuth": false,
              "sha256": "05v4hlnlsp8y60hy3k9aj4srwmka6b6qpmivjbzfiifw8ap04q9a",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/2.0.32/headless/linux64",
              "version": "2.0.32"
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
