# Nix nativefier

Makes electron apps from urls.

(This is WIP, I want to get rid of the zip at some time and clean this up a bit)


Usage:

```nix

(pkgs.callPackage ./natifier.nix {
  name = "nextcloud-gui";
  targetUrl = "https://try.nextcloud.com";
})
(pkgs.callPackage ./natifier.nix {
  name = "teamsium";
  targetUrl = "https://teams.microsoft.com";
  cfg.internalUrls = "https://teams\\.microsoft\\.com|https://login\\.microsoftonline\\.com/.*";
})
(pkgs.callPackage ./natifier.nix {
  name = "website";
  targetUrl = "https://beardhatcode.be";
  js = ''
    alert("oh hi there");
  '';
  css = ''
    body{background: "red";}
  '';
})
```


The zip is derived from [nativefier/nativefier](https://github.com/nativefier/nativefier).
