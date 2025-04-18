{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:
let
  pname = "crealityprint";
  version = "6.1.0-beta";

  src = fetchurl {
    url = "https://github.com/jamincollins/CrealityPrint/releases/download/v6.1.0-beta1/CrealityPrint-V6.1.0-x86_64-Beta.AppImage";
    sha256 = "sha256-54oR0pnpUjkHKc3FBjFeUvpU4VeTxd6guJH1cOLV5lw=";
  };

  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "CrealityPrint";
    comment = "3‑D Printer slicer by Creality";
    icon = "CrealityPrint"; # matches upstream filename
    categories = ["Graphics" "3DGraphics" "Engineering"];
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs:
      with pkgs; [
        zlib
        glib
        gtk3
        pango
        cairo
        gdk-pixbuf
        libsecret
        mesa
        xorg.libX11
        xorg.libxcb
        xorg.libXrandr
        xorg.libXi
        libxkbcommon
        wayland
        ffmpeg
        webkitgtk_4_0
      ];

    extraInstallCommands = ''
      install -Dm644 ${desktopItem}/share/applications/${pname}.desktop \
        $out/share/applications/${pname}.desktop

      if [ -d ${extracted}/usr/share/icons/hicolor ]; then
        cp -r --no-preserve=mode,ownership ${extracted}/usr/share/icons/hicolor \
          $out/share/icons/
      fi
    '';

    meta = with lib; {
      description = "Creality Print 3‑D slicer";
      homepage = "https://github.com/jamincollins/CrealityPrint";
      license = licenses.unfree;
      maintainers = with maintainers; [];
      platforms = ["x86_64-linux"];
      mainProgram = pname;
    };
  }
