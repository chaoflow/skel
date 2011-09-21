{
  packageOverrides = pkgs:
  {
    Py26Env = pkgs.buildEnv {
      name = "py26env";
      paths = [
        pkgs.defaultStdenv
        pkgs.gitAndTools.gitFull
        pkgs.libxml2
        pkgs.libxslt
        pkgs.python26
        pkgs.python26Packages.ipdb
        pkgs.python26Packages.readline
        pkgs.python26Packages.sqlite3
        pkgs.python26Packages.ssl
        pkgs.subversionClient
      ];
    };
    Py27Env = pkgs.buildEnv {
      name = "py27env";
      paths = [
        pkgs.defaultStdenv
        pkgs.gitAndTools.gitFull
        pkgs.libxml2
        pkgs.libxslt
        pkgs.python27
        pkgs.python27Packages.ipdb
        pkgs.python27Packages.pip
        pkgs.python27Packages.readline
        pkgs.python27Packages.sqlite3
        pkgs.python27Packages.ssl
        pkgs.subversionClient
        pkgs.zlib
      ];
      ignoreCollisions = true;
    };
    TestEnv = pkgs.buildEnv {
      name = "testenv";
      paths = [
        pkgs.defaultStdenv
        pkgs.python26
        pkgs.python26Packages.setuptools
        pkgs.python26Packages.ipython
      ];
    };
  };
}
