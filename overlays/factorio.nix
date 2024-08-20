_: {
  modifications = _final: prev: let
    versionsJson = prev.writeText "factorio-107.json" ''
      {
        "x86_64-linux": {
          "alpha": {
            "stable": {
              "name": "factorio_alpha_x64-1.1.107.tar.xz",
              "needsAuth": true,
              "sha256": "16hkyfwp02zcijka4yslifz62ry6hrvk0w9960618kqdw3gr7p82",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/1.1.107/alpha/linux64",
              "version": "1.1.107"
            }
          },
          "headless": {
            "stable": {
              "name": "factorio_headless_x64-1.1.107.tar.xz",
              "needsAuth": false,
              "sha256": "10ds1nz9sbx9xz1lyypf16wncc6323vpm7l5p11d6iy4cha85wsw",
              "tarDirectory": "x64",
              "url": "https://factorio.com/get-download/1.1.107/headless/linux64",
              "version": "1.1.107"
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
