# This is mostly a work in progress and might not work with what is in
# nixpkgs trunk. If you have questions, feel free to contact me:
# Florian Friesdorf <flo@chaoflow.net>

{
  firefox.jre = true;
  libreoffice.force = true;
  packageOverrides = pkgs:
  {
    envTex = pkgs.buildEnv {
      name = "mytex";
      paths = with pkgs; [
        (let myTexLive = 
          pkgs.texLiveAggregationFun {
            paths =
              [ pkgs.texLive
                pkgs.texLiveCMSuper
                pkgs.texLiveExtra
                pkgs.texLiveBeamer ];
          };
         in myTexLive)
      ];
    };

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
#        python27Packages.site
        subversionClient
        stdenv
      ];
    };

    mpl = pkgs.buildEnv {
      name = "mpl";
      paths = with pkgs; [
          (python27Full.override {
            extraLibs = [
#              python27Packages.needsmpl
              python27Packages.ipython
            ];
          })
      ];
    };

    # we want ipython with custom modules!
    ipythonenv = pkgs.buildEnv {
      name = "ipythonenv";
      paths = with pkgs; [
        python27Packages.ipython
      ];
    };


    # we want virtualenv with custom modules!
    venv = pkgs.buildEnv {
      name = "venv";
      paths = with pkgs; [
        python27Packages.virtualenv
      ];
    };

    venv26 = pkgs.buildEnv {
      name = "venv26";
      paths = with pkgs; [
        python26Packages.virtualenv
      ];
    };

    mpl26 = pkgs.buildEnv {
      name = "mpl26";
      paths = with pkgs; [
          (python26Full.override {
            extraLibs = [
 #             python26Packages.needsmpl
              python26Packages.ipython
            ];
          })
      ];
    };

    pythonWithAll = pkgs.buildEnv {
      name = "python-with-all";
      paths = with pkgs; [
          python27Full
      ] ++ (lib.filter (v: builtins.isAttrs v && v ? type && v.type == "derivation")
                       (lib.attrValues python27Packages));
    };

    py27 = pkgs.buildEnv {
      name = "py27";
      paths = with pkgs; [
        cyrus_sasl
        db4
        file
        gitAndTools.gitFull
        groff
        jdk
        libxml2
        libxslt
        mercurial
        mysql
        openldap
        openssh
        openssl
        pcre
        pkgconfig
        postgresql
        pycrypto
        python27Full
        python27Packages.ipython
        python27Packages.pyyaml
        python27Packages.readline
#        python27Packages.site
        python27Packages.sqlite3
        python27Packages.virtualenv
        subversionClient
        stdenv
        wget
        zlib
      ];
    };

    starenv = pkgs.buildEnv {
      name = "starenv";
      paths = with pkgs; [
        autoconf
        cyrus_sasl
        db4
        file
        ghostscript
        gitAndTools.gitFull
        groff
        jdk
        libtiff
        libxml2
        libxslt
        lynx
        mercurial
        openldap
        openssh
        openssl
        pcre
        #pdftk
        pkgconfig
        postgresql
        readline
        sqlite
        subversionClient
        stdenv
        tesseract
        wget
        xpdf
        zlib
      ];
    };

    pysidenv = pkgs.buildEnv {
      name = "pysidenv";
      paths = with pkgs; [
        file
        gitAndTools.gitFull
        less
        pyside
        python27Full
        python27Packages.dateutil # undeclared dep of matplotlib
        python27Packages.ipython
        python27Packages.matplotlib
        python27Packages.numpy  # undeclared dep of matplotlib
        python27Packages.pyyaml
        python27Packages.readline
        python27Packages.scipy
#        python27Packages.site
        python27Packages.sqlite3
        python27Packages.virtualenv
        qt4
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
