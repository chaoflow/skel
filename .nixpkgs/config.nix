# This is mostly a work in progress and might not work with what is in
# nixpkgs trunk. If you have questions, feel free to contact me:
# Florian Friesdorf <flo@chaoflow.net>

{
  allowUnfree = true;
  chromium.enableGoogleTalkPlugin = true;
  chromium.enablePepperFlash = true;
  firefox.jre = false;
  firefox.enableAdobeFlash = true;
  firefox.enableGoogleTalkPlugin = true;
  git.guiSupport = true;
  libreoffice.force = true;
  pulseaudio = true; # XXX: this recompiles chromium
  packageOverrides = pkgs:
  rec {
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

    # ipython sites for some python versions with all wheels
    ipythonSites = pkgs.buildEnv {
      name = "ipython-sites";
      paths = map
        (python: python.site {
          name = "ipython-all-wheels";
          wheels = python.wheels.all.wheels;
          scriptsFor = [ python.wheels.ipython ];
          pickPolicy = cur: new: pkgs.lib.versionOlder cur.version new.version;

          # XXX: needed as currently it is not ensured that versioned scripts exist
          postBuild =
            "install $out/bin/ipython $out/bin/ipython${python.majorVersion}";
        })
        [ pkgs.python27 pkgs.python32 pkgs.python33 pkgs.python34 ];

      # XXX: needed until a story for unversioned scripts is told
      ignoreCollisions = true;
    };

    # ipython for some python versions with all wheels, but without the site
    ipythons = pkgs.buildEnv {
      name = "ipythons";
      paths = map
        (python: python.tool {
          name = "ipython-all-wheels-${python.majorVersion}";
          wheel = python.wheels.ipython;
          wheels = python.wheels.all.wheels;
          pickPolicy = cur: new: pkgs.lib.versionOlder cur.version new.version;

          # XXX: needed as currently it is not ensured that versioned scripts exist
          fixupPhase =
            "install $out/bin/ipython $out/bin/ipython${python.majorVersion}";
        })
        [ pkgs.python27 pkgs.python32 pkgs.python33 pkgs.python34 ];

      # XXX: needed until a story for unversioned scripts is told
      ignoreCollisions = true;
    };


    ### Below here probably outdated things pending review.

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

    # I use these mostly to have an offline copy of all python packages
    pythonWithAll = pythonWithAll27;
    pythonWithAll26 = pkgs.buildEnv {
      name = "python-with-all-2.6";
      paths = with pkgs; [
          python26
      ] ++ (lib.filter (v: (v.type or null) == "derivation")
                       (lib.attrValues (removeAttrs python26Packages
                                                    [ "recursivePthLoader"
                                                      "setuptools"
                                                      "setuptoolsSite"
                                                    ])));
      ignoreCollisions = true;
    };
    pythonWithAll27 = pkgs.buildEnv {
      name = "python-with-all-2.7";
      paths = with pkgs; [
          python27
      ] ++ (lib.filter (v: (v.type or null) == "derivation")
                       (lib.attrValues (removeAttrs python27Packages
                                                    [ "recursivePthLoader"
                                                      "setuptools"
                                                      "setuptoolsSite"
                                                    ])));
      ignoreCollisions = true;
    };

    pytest = pkgs.buildEnv {
      name = "pytest";
      paths = with pkgs; [
        (python27Full.override {
          extraLibs = [
            python27Packages.ipython
          ];
        })
        python27Packages.matplotlib
        python27Packages.nose
        python27Packages.readline
      ];
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
      ignoreCollisions = true;
      name = "starenv";
      paths = with pkgs; [
        aespipe
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
        (python26Full.override {
          extraLibs = [
            python26Packages.pycrypto
          ] ++ lib.attrValues python26.modules;
        })
        (python27Full.override {
          extraLibs = [
            python27Packages.pycrypto
          ] ++ lib.attrValues python27.modules;
        })
        python27Packages.virtualenv
        readline
        sqlite
        subversionClient
        stdenv
        tesseract
        vim
        wget
        xpdf
        zlib
      ];
    };

    pysideenv = pkgs.buildEnv {
      name = "pysideenv";
      paths = with pkgs; [
        file
        gitAndTools.gitFull
        less
        pyside
        python27Full
        python27Packages.ipython
        python27Packages.matplotlib
        python27Packages.pyyaml
        python27Packages.scipy
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
}
