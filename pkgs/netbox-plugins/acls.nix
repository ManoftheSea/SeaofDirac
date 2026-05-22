{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  django,
  python,
}: let
  version = "1.9.1";
in
  buildPythonPackage {
    inherit version;
    pname = "netbox-acls";
    pyproject = true;

    disabled = python.pythonVersion != netbox.python.pythonVersion;

    src = fetchFromGitHub {
      owner = "netbox-community";
      repo = "netbox-acls";
      hash = "sha256-2phJIbWxVEQ3+3PQFPQj7MS39Svho+I/XWJ3JNgEQJk=";
      tag = version;
    };

    build-system = [setuptools];

    nativeCheckInputs = [
      netbox
      django
    ];

    preFixup = ''
      export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
    '';

    pythonImportsCheck = ["netbox_acls"];

    meta = {
      description = "Netbox plugin for managing Access Lists";
      homepage = "https://github.com/netbox-community/netbox-acls";
      changelog = "https://github.com/netbox-community/netbox-acls/releases/tag/${version}";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
      maintainers = [];
    };
  }
