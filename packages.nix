{
  config,
  pkgs,
  lib,
  ...
}:
let
  suyu_script = pkgs.writeShellScriptBin "suyu" "
    bash appimage-run ./Downloads/Suyu-Linux_x86_64.AppImage
  ";
  tooglewallpaper_script = pkgs.writeShellScriptBin "toogleWallpaper_sh" "
    bash /usr/local/bin/toogleWallpaper.sh
  ";
  wallpaper_script = pkgs.writeShellScriptBin "wallpaper_sh" "
    bash /usr/local/bin/wallpaper.sh
  ";
  startn_script = pkgs.writeShellScriptBin "startn" "
    bash /usr/local/bin/startn.sh
  ";
  quit_niri_script = pkgs.writeShellScriptBin "quit_niri_sh" "
    bash /usr/local/bin/quit_niri.sh
  ";
  firefox-sync = pkgs.writeShellScriptBin "firefox-sync" ''
        static=static-$1
        link=$1
        volatile=/dev/shm/firefox-$1-$USER

        IFS=
        set -efu

        cd ~/.mozilla/firefox

        if [ ! -r $volatile ]; then
        	mkdir -m0700 $volatile
        fi

        if [ "$(readlink $link)" != "$volatile" ]; then
    	    mv $link $static
    	    ln -s $volatile $link
        fi

        if [ -e $link/.unpacked ]; then
    	    rsync -av --delete --exclude .unpacked ./$link/ ./$static/
        else
    	    rsync -av ./$static/ ./$link/
    	    touch $link/.unpacked
        fi
  '';
in
{
  imports = [
    #aagl.module
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.psutil
    ]))
    git
    lazygit
    tinymist
    niri
    neovim
    #zed-editor
    android-studio
    firefox
    #xfce.thunar
    #xfce.thunar-volman
    pipewire
    pavucontrol
    swaybg
    xwayland-satellite
    htop
    python3
    #foot

    #clang
    rustc
    rust-analyzer
    cargo
    wl-clipboard

    gvfs
    xorg.xeyes
    qalculate-gtk
    libreoffice
    localsend
    appimage-run
    steam
    sway
    swayosd
    waybar
    #mpv
    openjdk
    mpvpaper
    wofi
    gnome-themes-extra
    _7zz
    mako
    libnotify
    obs-studio
    imagemagick
    grim
    swaylock
    nomacs
    suyu_script

    libsForQt5.qt5ct
    qt6ct

    #docker
    #docker-compose

    nodejs
    unzip
    clang-tools
    hunspell
    hunspellDicts.es_MX
    hunspellDicts.en_US
    prismlauncher
    linux-wifi-hotspot

    # lsp servers
    #nil
    #tinymist

    #formaters
    #typstyle

    wl-mirror
    rsync
    zed-editor
    gnupg
    pinentry-tty
    apple-cursor
    nautilus # Needed for gtk4 FileChooserNative
    yazi
    jaq

    firefox-sync
    quit_niri_script
    startn_script
    wallpaper_script
    tooglewallpaper_script
  ];
  systemd.user.services.firefox-profile-memory-cache = {
    description = "Firefox profile memory cache";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rsync ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''${firefox-sync}/bin/firefox-sync 0shu6evv.default'';
      ExecStop = ''${firefox-sync}/bin/firefox-sync 0shu6evv.default'';
    };
  };
}
