pkgs : {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  firefox = {
    jre = false;
    enableAdobeFlash = false;
    enableGoogleTalkPlugin = false;
    icedtea = true;
  };
  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);
  packageOverrides = self : rec {
    firefox = self.firefox.override { enableGTK3 = true; };
    emacs = self.emacs.override { withGTK2 = false; withGTK3 = true; };
    hsEnv = self.haskellPackages.ghcWithPackages (self : with self; [
      xmonad
      xmonad-contrib
    ]);
    graphical = self.buildEnv {
      name = "myGraphical";
      paths = with self; ([
        # Envs
        #cs225
        #dev
        #orpheum
        shell
        #profile
        #mumc

        # Pkgs
        chromium
        consul
        dmenu
        #emacs
        firefoxWrapper
        #filezilla
        gimp
        gnupg21
        hsEnv
        icedtea_web
        #libreoffice
        mumble
        mupdf
        nix-repl
        #nixops
        #notbit
        xfce.parole
        pavucontrol
        pcsclite
        pinentry
        pulseaudioFull
        quasselClient_qt5
        scrot
        sl
        speedtest_cli
        st
        #sup
        #virtmanager
        vlc
        xcompmgr
        xlibs.xbacklight
        #zathura
        vault
      ]);
    };
    profile = self.myEnvFun {
      name = "profile";
      buildInputs = with self; [
        (self.haskellPackages.ghcWithPackages (self : with self; [
          hakyll
        ]))
      ];
    };
    nongraphical = self.buildEnv {
      name = "myNonGraphical";
      paths = with self; [
        #dev
        shell
      ];
    };
    dev = self.buildEnv {
      name = "myDev";
      paths = with self; [
        cdrkit
        #python3Packages.ipython
        subversion
      ];
    };
    shell = self.buildEnv {
      name = "myShell";
      paths = with self; [
        acpi
        fish
        git
        htop
        mosh
        opensc
        openssh #_hpn
        openssl
        psmisc
        tmux
        unzip
        vim
        wget
      ];
    };
    mumc = self.myEnvFun {
      name = "mumble-connect";
      buildInputs = with self; [
        stdenv
        autoconf
        automake
        libtool
        pkgconfig
        valgrind
      ];
    };
    cs225 = self.myEnvFun {
      name = "cs225";
      buildInputs = with self; [
        gdb
        imagemagick
        libpng
        stdenv
        valgrind
      ];
    };
    orpheum = self.myEnvFun {
      name = "orpheum";
      buildInputs = (with self; [ python27
      #rubyLibs.sass_3_3_4
      ])
        ++ (with self.python27Packages; [
          django_1_5 google_api_python_client paypalrestsdk pil sorl_thumbnail six sqlite3
        ]);
    };
  };
}
