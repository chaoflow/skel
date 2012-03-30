# This is mostly a work in progress and might not work with what is in
# nixpkgs trunk. If you have questions, feel free to contact me:
# Florian Friesdorf <flo@chaoflow.net>

{
  firefox.jre = true;
  libreoffice.force = true;
  packageOverrides = pkgs:
  {
    envPythonPlonedev = pkgs.buildEnv {
      name = "env-python-plonedev-1.0";
      paths = with pkgs; [
        cyrus_sasl
        db4
        gitAndTools.gitFull
        groff
        libxml2
        libxslt
        openssh
        openssl
        python27Full
        python27Packages.ipython
        python27Packages.site
        subversionClient
        stdenv
      ];
    };

    pythonWithAll = pkgs.buildEnv {
      name = "python-with-all";
      paths = with pkgs; [
          python27Full
      ] ++ lib.attrValues (removeAttrs python27Packages [
          "buildPythonPackage"
          "fetchurl"
          "fetchsvn"
          "python"
          "stdenv"
          "wrapPython"
          # broken
          "pysvn"
      ]);
      ignoreCollisions = true;
    };

    py27 = pkgs.buildEnv {
      name = "py27";
      paths = with pkgs; [
        cyrus_sasl
        db4
        file
        gitAndTools.gitFull
        groff
        pcre
        libxml2
        libxslt
        mercurial
        openldap
        openssh
        openssl
        pkgconfig
        postgresql
        pycrypto
        python27Full
        python27Packages.ipython
        python27Packages.site
        python27Packages.virtualenv
        subversionClient
        stdenv
        wget
        zlib
      ];
    };

    KernelEnv = pkgs.buildEnv {
      name = "kernelenv";
      paths = [
        pkgs.defaultStdenv
        pkgs.gitAndTools.gitFull
        pkgs.ncurses
      ];
    };
  };
  pkgs.pulseaudio = {
    jackaudioSupport = true;
  };
}
