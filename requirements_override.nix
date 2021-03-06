{ pkgs, python }:

with pkgs.lib;
with builtins;

self: super:

let filterValid = filterAttrs (name: value: hasAttr name super);

in filterValid {
  "apipkg" = super."apipkg".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."setuptools-scm" ]; });

  "execnet" = super."execnet".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."setuptools-scm" ]; });

  "mccabe" = super."mccabe".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."pytest-runner" ]; });

  "py" = super."py".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."setuptools-scm" ]; });

  "pytest-django" = super."pytest-django".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."setuptools-scm" ]; });

  "setuptools" = super."setuptools".overrideDerivation
    (old: { pipInstallFlags = [ "--ignore-installed" "--no-deps" ]; });

  "pip" = super."pip".overrideDerivation
    (old: { pipInstallFlags = [ "--ignore-installed" "--no-deps" ]; });

  "pytest-black" = super."pytest-black".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."setuptools-scm" ]; });

  "wheel" = super."wheel".overrideDerivation
    (old: { pipInstallFlags = [ "--ignore-installed" "--no-deps" ]; });

  "zipp" = super."zipp".overrideDerivation
    (old: { buildInputs = old.buildInputs ++ [ self."toml" ]; });

}
