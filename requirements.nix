{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.lib) fix' extends inNixShell;

  pythonPackages = pkgs.python37.pkgs;

  commonBuildInputs = with pkgs; [
    freetype.dev
    openblas.dev
    gfortran
    liblapack
    libpng
    libjpeg
    libffi
    pkg-config
    pythonPackages.numpy
  ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python37-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs) ++ [
          pythonPackages.scikitimage
          pythonPackages.scikitlearn
          pythonPackages.pywavelets
          pythonPackages.pytorch
          pythonPackages.numpy
          pythonPackages.scipy
          pythonPackages.pandas
        ];
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // {
        nativeBuildInputs = (args.nativeBuildInputs or []) ++ args.buildInputs;
        pipInstallFlags = [ "--ignore-installed" "--no-deps" ];
        catchConflicts = false;
      });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "cffi" = python.mkDerivation {
      name = "cffi-1.11.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz";
        sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."pycparser"
      ];
      meta = with pkgs.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };

    "cloudpickle" = python.mkDerivation {
      name = "cloudpickle-0.5.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/56/d0/30b94aecd2e052dda921dfd6468846120dfa2927e0e0476590398fbe6eec/cloudpickle-0.5.3.tar.gz";
        sha256 = "54858c7b7dc763ed894ff91059c1d0b017d593fe23850d3d8d75f47d98398197";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/cloudpipe/cloudpickle";
        license = licenses.bsdOriginal;
        description = "Extended pickling support for Python objects";
      };
    };

    "cycler" = python.mkDerivation {
      name = "cycler-0.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz";
        sha256 = "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.lib; {
        homepage = "http://github.com/matplotlib/cycler";
        license = licenses.bsdOriginal;
        description = "Composable style cycles";
      };
    };

    "cython" = python.mkDerivation {
      name = "cython-0.29.21";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6c/9f/f501ba9d178aeb1f5bf7da1ad5619b207c90ac235d9859961c11829d0160/Cython-0.29.21.tar.gz";
        sha256 = "e57acb89bd55943c8d8bf813763d20b9099cc7165c0f16b707631a7654be9cad";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://cython.org/";
        license = licenses.asl20;
        description = "The Cython compiler for writing C extensions for the Python language.";
      };
    };

    "dask" = python.mkDerivation {
      name = "dask-0.18.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c0/5c/32a32e72d831a879a960d1e013c29351bd808e3060121d94efbc340db49f/dask-0.18.2.tar.gz";
        sha256 = "8fba559911788010ecedf58e540004d56d09f7829a1400dd72b74ffedafafabc";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://github.com/dask/dask/";
        license = licenses.bsdOriginal;
        description = "Parallel PyData with Task Scheduling";
      };
    };

    "decorator" = python.mkDerivation {
      name = "decorator-4.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz";
        sha256 = "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = licenses.bsdOriginal;
        description = "Better living through Python with decorators";
      };
    };

    "imageio" = python.mkDerivation {
      name = "imageio-2.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/99/c5/16b4e3e9078ccb92a8b010455e62bd77585e807aff44028d6c70fc2b62df/imageio-2.3.0.tar.gz";
        sha256 = "c4fd5183c342d47fdc2e98552d14e3f24386021bbc3efedd1e3b579d7d249c07";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."pillow"
      ];
      meta = with pkgs.lib; {
        homepage = "http://imageio.github.io/";
        license = licenses.bsdOriginal;
        description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats.";
      };
    };

    "kiwisolver" = python.mkDerivation {
      name = "kiwisolver-1.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/31/60/494fcce70d60a598c32ee00e71542e52e27c978e5f8219fae0d4ac6e2864/kiwisolver-1.0.1.tar.gz";
        sha256 = "ce3be5d520b4d2c3e5eeb4cd2ef62b9b9ab8ac6b6fedbaa0e39cdb6f50644278";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."setuptools"
      ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/nucleic/kiwi";
        license = "UNKNOWN";
        description = "A fast implementation of the Cassowary constraint solver";
      };
    };

    "matplotlib" = python.mkDerivation {
      name = "matplotlib-2.2.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ec/ed/46b835da53b7ed05bd4c6cae293f13ec26e877d2e490a53a709915a9dcb7/matplotlib-2.2.2.tar.gz";
        sha256 = "4dc7ef528aad21f22be85e95725234c5178c0f938e2228ca76640e5e84d8cde8";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."cycler"
        self."kiwisolver"
        self."pyparsing"
        self."python-dateutil"
        self."pytz"
        self."six"
      ];
      meta = with pkgs.lib; {
        homepage = "http://matplotlib.org";
        license = licenses.psfl;
        description = "Python plotting package";
      };
    };

    "networkx" = python.mkDerivation {
      name = "networkx-2.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/11/42/f951cc6838a4dff6ce57211c4d7f8444809ccbe2134179950301e5c4c83c/networkx-2.1.zip";
        sha256 = "64272ca418972b70a196cb15d9c85a5a6041f09a2f32e0d30c0255f25d458bb1";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."decorator"
      ];
      meta = with pkgs.lib; {
        homepage = "http://networkx.github.io/";
        license = licenses.bsdOriginal;
        description = "Python package for creating and manipulating graphs and networks";
      };
    };

    "pillow" = python.mkDerivation {
      name = "pillow-5.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d3/c4/b45b9c0d549f482dd072055e2d3ced88f3b977f7b87c7a990228b20e7da1/Pillow-5.2.0.tar.gz";
        sha256 = "f8b3d413c5a8f84b12cd4c5df1d8e211777c9852c6be3ee9c094b626644d3eab";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://python-pillow.org";
        license = "License :: Other/Proprietary License";
        description = "Python Imaging Library (Fork)";
      };
    };

    "pycparser" = python.mkDerivation {
      name = "pycparser-2.18";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz";
        sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };

    "pygit" = python.mkDerivation {
      name = "pygit-0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cd/e8/839dacf13a5de30eff7e0815a3cfc051bd80532f83d862e0c14433b03286/pygit-0.1.tar.gz";
        sha256 = "fe02a667309e044069053313a1cb056012be10388e7ae284ebbd35480d7be58e";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://code.istique.net/?p=pygit.git;a=summary";
        license = "UNKNOWN";
        description = "Git Bindings for Python";
      };
    };

    "pyparsing" = python.mkDerivation {
      name = "pyparsing-2.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz";
        sha256 = "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://pyparsing.wikispaces.com/";
        license = licenses.mit;
        description = "Python parsing module";
      };
    };

    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.7.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz";
        sha256 = "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."six"
        self."setuptools"
        self."setuptools-scm"
      ];
      meta = with pkgs.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = licenses.bsdOriginal;
        description = "Extensions to the standard Python datetime module";
      };
    };

    "pytz" = python.mkDerivation {
      name = "pytz-2018.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz";
        sha256 = "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };

    "pyyaml" = python.mkDerivation {
      name = "pyyaml-5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz";
        sha256 = "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/yaml/pyyaml";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };

    "setuptools" = python.mkDerivation {
      name = "setuptools-49.1.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d0/4a/22ee76842d8ffc123d4fc48d24a623c1d206b99968fe3960039f1efc2cbc/setuptools-49.1.3.zip";
        sha256 = "ea484041dc6495c4ee74dd578470866e3043f6d1c998cfafbdb1f668f1768284";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/pypa/setuptools";
        license = licenses.mit;
        description = "Easily download, build, install, upgrade, and uninstall Python packages";
      };
    };

    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-5.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/af/df/f8aa8a78d4d29e0cffa4512e9bc223ed02f24893fe1837c6cee2749ebd67/setuptools_scm-5.0.1.tar.gz";
        sha256 = "c85b6b46d0edd40d2301038cdea96bb6adc14d62ef943e75afb08b3e7bcf142a";
};
      doCheck = commonDoCheck;
      format = "pyproject";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
        self."wheel"
      ];
      propagatedBuildInputs = [
        self."setuptools"
      ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.11.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz";
        sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://pypi.python.org/pypi/six/";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "toolz" = python.mkDerivation {
      name = "toolz-0.9.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/14/d0/a73c15bbeda3d2e7b381a36afb0d9cd770a9f4adc5d1532691013ba881db/toolz-0.9.0.tar.gz";
        sha256 = "929f0a7ea7f61c178bd951bdae93920515d3fbdbafc8e6caf82d752b9b3b31c9";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://github.com/pytoolz/toolz/";
        license = licenses.bsdOriginal;
        description = "List processing tools and functional utilities";
      };
    };

    "torchvision" = python.mkDerivation {
      name = "torchvision-0.1.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a7/15/b78b0a56af3395c7e93ab2d70e9b99ed63aef4522a260334f9dda36edc0f/torchvision-0.1.6.tar.gz";
        sha256 = "8b6b29e5cdeff91d6ba9a3448db442a22f6839f7a362fd09f11919b915072519";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/pytorch/vision";
        license = licenses.bsdOriginal;
        description = "image and video datasets and models for torch deep learning";
      };
    };

    "tqdm" = python.mkDerivation {
      name = "tqdm-4.24.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/92/cb/2b07b529284f324293a8919185cc4b15007f32a2aba64c93b0c1696a26f3/tqdm-4.24.0.tar.gz";
        sha256 = "60bbaa6700e87a250f6abcbbd7ddb33243ad592240ba46afce5305b15b406fad";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/tqdm/tqdm";
        license = licenses.mit;
        description = "Fast, Extensible Progress Meter";
      };
    };

    "wheel" = python.mkDerivation {
      name = "wheel-0.35.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/83/72/611c121b6bd15479cb62f1a425b2e3372e121b324228df28e64cc28b01c2/wheel-0.35.1.tar.gz";
        sha256 = "99a22d87add3f634ff917310a3d87e499f19e663413a52eb9232c447aa646c9f";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [
        self."setuptools"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/pypa/wheel";
        license = licenses.mit;
        description = "A built-package format for Python";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
