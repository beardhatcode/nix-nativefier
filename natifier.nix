{ electron_10
, dpkg
, fetchurl
, glib
, unzip
, lib
, jq
, makeWrapper
, stdenv
, wrapGAppsHook
, name
, targetUrl
, css ? ""
, js ? ""
, cfg ? { }
, ...
}:
let
  totcfg = builtins.toJSON (
    {
      "alwaysOnTop" = false;
      "backgroundColor" = null;
      "basicAuthPassword" = null;
      "basicAuthUsername" = null;
      "bounce" = false;
      "clearCache" = false;
      "counter" = false;
      "darwinDarkModeSupport" = false;
      "disableGpu" = false;
      "diskCacheSize" = null;
      "enableEs3Apis" = false;
      "fastQuit" = false;
      "flashPluginDir" = null;
      "fullScreen" = false;
      "globalShortcuts" = null;
      "height" = 800;
      "ignoreCertificate" = false;
      "ignoreGpuBlacklist" = false;
      "insecure" = false;
      "internalUrls" = null;
      "blockExternalUrls" = false;
      "maximize" = false;
      "name" = name;
      "nativefierVersion" = "42.2.0";
      "proxyRules" = null;
      "showMenuBar" = false;
      "singleInstance" = false;
      "targetUrl" = targetUrl;
      "titleBarStyle" = null;
      "tray" = false;
      "userAgent" = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36";
      "width" = 1280;
      "win32metadata" = { };
      "disableOldBuildWarning" = false;
      "zoom" = 1;
      "buildDate" = 1611769833008;
    } // cfg
  );
in
stdenv.mkDerivation rec {
  pname = name;
  version = "1.8.5";

  src = ./natifier.zip;

  nativeBuildInputs = [
    unzip
    jq
    makeWrapper
  ];

  buildInputs = [
    unzip
  ];


  unpackPhase = ''
    target="$out/share/data-${lib.strings.sanitizeDerivationName name}"
    mkdir -p "$target"
    unzip $src -d $target
    mv $target/package.json $target/package.json.old
    jq '.name="natifier-${lib.strings.sanitizeDerivationName name}"' $target/package.json.old > $target/package.json
    rm $target/package.json.old
    echo ${lib.strings.escapeShellArg js} > $target/inject/inject.js
    echo ${lib.strings.escapeShellArg css} > $target/inject/inject.css
    echo ${lib.strings.escapeShellArg totcfg} > $target/nativefier.json
  '';

  installPhase = ''true'';

  postFixup = ''
    makeWrapper ${electron_10}/bin/electron \
      $out/bin/${name} \
      --add-flags $out/share/data-${name}
  '';

  meta = with stdenv.lib; {
    homepage = "natifier";
    description = "A net (beardhatcode spin)";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };

}
