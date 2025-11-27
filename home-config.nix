{ pkgs, ... }:
let
  #home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  PS1_CMD1 = "$(git branch --show-current 2>/dev/null)";
in
{
  #imports = [
  #   (import "${home-manager}/nixos")
  #];

  #home-manager.users.ale =
  #{
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "26.05";
  # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];

  # Programs
  programs.eww.enable = true;
  programs.bash.enable = true;
  programs.foot.enable = true;
  programs.mpv.enable = true;
  programs.zed-editor.enable = true;
  gtk.enable = true;
  services.swayosd.enable = true;

  # Configs
  programs.git.settings = {
    enable = true;
    userName = "1L5TH";
    userEmail = "aleth2k@gmail.com";
  };

  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
    })
  ];
  qt.enable = true;
  qt.platformTheme.name = "qtct";
  qt.style.name = "kvantum";
  xdg.configFile."Kvantum/kvantum.kvconfig".source =
    (pkgs.formats.ini { }).generate "kvantum.kvconfig"
      {
        General.theme = "catppuccin-mocha-mauve";
      };

  programs.foot.settings = {
    main = {
      font = "liberation mono:size=12";
      dpi-aware = false;
    };

    colors = {
      alpha = 0.7;
      background = "000000";
      foreground = "FFFFFF";
      ## Normal/regular colors (color palette 0-7)
      regular0 = "000000"; # black
      regular1 = "cd0000"; # red
      regular2 = "00cd00"; # green
      regular3 = "cdcd00"; # yellow
      regular4 = "0000ee"; # blue
      regular5 = "cd00cd"; # magenta
      regular6 = "00cdcd"; # cyan
      regular7 = "e5e5e5"; # white

      ## Bright colors (color palette 9-15)
      bright0 = "7f7f7f"; # bright black
      bright1 = "ff0000"; # bright red
      bright2 = "00ff00"; # bright green
      bright3 = "ffff00"; # bright yellow
      bright4 = "5c5cff"; # bright blue
      bright5 = "ff00ff"; # bright magenta
      bright6 = "00ffff"; # bright cyan
      bright7 = "ffffff"; # bright white
    };
  };

  programs.bash = {
    #enable = true;
    initExtra = ''
      export QT_QPA_PLATFORMTHEME="qt5ct";
      export QT6_PLATFORMTHEME="qt6ct";
      export NIXPKGS_ALLOW_UNFREE=1;

      [[ $- != *i* ]] && return
      alias snvim='sudo -E nvim'
      PS1='[\[\e[96m\]\u\[\e[0m\]@\[\e[95m\]\h\[\e[0m\] \[\e[92m\]\W\[\e[0m\]] <\[\e[96m\]${PS1_CMD1}\[\e[0m\]> \\$ '
    '';
  };

  programs.zed-editor.extensions = [
    "log"
    "nix"
    "basher"
    "typst"
  ];
  programs.zed-editor.userKeymaps = builtins.fromJSON (builtins.readFile ./configs/zed/keymap.json);
  programs.zed-editor.userSettings = builtins.fromJSON (
    builtins.readFile ./configs/zed/settings.json
  );
  xdg.configFile."zed/tasks.json".source = ./configs/zed/tasks.json;
  programs.zed-editor.extraPackages = with pkgs; [
    nil
    nixfmt-rfc-style
    tinymist
    typstyle
    clang-tools
    python313Packages.python-lsp-server
    python313Packages.pylint
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      cursor-theme = "macOS";
    };
  };

  gtk.gtk3.bookmarks = [
    "file:///home/ale/Documents"
    "file:///home/ale/Videos"
    "file:///home/ale/Music"
    "file:///home/ale/Pictures"
    "file:///home/ale/Downloads"
  ];
  gtk.gtk3.extraConfig = {
    gtk-icon-theme-name = "Adwaita";
    gtk-theme-name = "Adwaita-dark";
    gtk-application-prefer-dark-theme = 1;
    gtk-cursor-theme-name = "macOS";
  };
  gtk.gtk4.extraConfig = {
    gtk-icon-theme-name = "Adwaita";
    gtk-theme-name = "Adwaita-dark";
    gtk-application-prefer-dark-theme = 1;
    gtk-cursor-theme-name = "macOS";
  };
  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 32;
  };
  programs.mpv.config = {
    hwdec = "vaapi";
    hwdec-codecs = "all";
    gpu-api = "opengl";
  };
  # programs.tofi.settings = {
  #   width = "100%";
  #   height = "100%";
  #   border-width = 0;
  #   outline-width = 0;
  #   padding-left = "35%";
  #   padding-top = "35%";
  #   result-spacing = 25;
  #   num-results = 5;
  #   font = "/nix/var/nix/profiles/system/sw/share/X11/fonts/JetBrainsMonoNerdFont-Medium.ttf";
  #   hint-font = false;
  #   background-color = "#000A";
  #   ascii-input = true;
  #   selection-color = "#7fc8ff";
  #   drun-launch=false;
  # };

  xdg.configFile."Thunar/uca.xml".source = ./configs/thunar.uca.xml;

  xdg.configFile."niri/config.kdl".source = ./configs/niri/config.kdl;

  xdg.configFile."mako/config".source = ./configs/mako/config;

  xdg.configFile."waybar/config".source = ./configs/waybar/config;
  xdg.configFile."waybar/style.css".source = ./configs/waybar/style.css;

  xdg.configFile."eww/eww.scss".source = ./configs/eww/eww.scss;
  xdg.configFile."eww/eww.yuck".source = ./configs/eww/eww.yuck;
  xdg.configFile."eww/modules/battery.yuck".source = ./configs/eww/modules/battery.yuck;
  xdg.configFile."eww/modules/clock.yuck".source = ./configs/eww/modules/clock.yuck;
  xdg.configFile."eww/modules/cpu.yuck".source = ./configs/eww/modules/cpu.yuck;
  xdg.configFile."eww/modules/focused-window.yuck".source = ./configs/eww/modules/focused-window.yuck;
  xdg.configFile."eww/modules/network.yuck".source = ./configs/eww/modules/network.yuck;
  xdg.configFile."eww/modules/niri-workspaces.yuck".source =
    ./configs/eww/modules/niri-workspaces.yuck;
  xdg.configFile."eww/modules/ram.yuck".source = ./configs/eww/modules/ram.yuck;
  xdg.configFile."eww/modules/temp.yuck".source = ./configs/eww/modules/temp.yuck;
  xdg.configFile."eww/modules/calendar.yuck".source = ./configs/eww/modules/calendar.yuck;
  xdg.configFile."eww/scripts/niri-focused-window.sh".source =
    ./configs/eww/scripts/niri-focused-window.sh;
  xdg.configFile."eww/scripts/niri-workspaces.sh".source = ./configs/eww/scripts/niri-workspaces.sh;
  xdg.configFile."eww/scripts/nmcli-monitor.sh".source = ./configs/eww/scripts/nmcli-monitor.sh;
  xdg.configFile."eww/scripts/calendar.sh".source = ./configs/eww/scripts/calendar.sh;
  xdg.configFile."eww/scripts/multimonitor.sh".source = ./configs/eww/scripts/multimonitor.sh;

  xdg.configFile."wofi/scripts/menu-left".source = ./configs/wofi/scripts/menu-left;
  xdg.configFile."wofi/scripts/menu-right".source = ./configs/wofi/scripts/menu-right;
  xdg.configFile."wofi/scripts/theme-select".source = ./configs/wofi/scripts/theme-select;
  xdg.configFile."wofi/colors.css".source = ./configs/wofi/colors.css;
  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/menu-right.conf".source = ./configs/wofi/menu-right.conf;
  xdg.configFile."wofi/menu-right.css".source = ./configs/wofi/menu-right.css;
  xdg.configFile."wofi/menu-theme.conf".source = ./configs/wofi/menu-theme.conf;
  xdg.configFile."wofi/menu-theme.css".source = ./configs/wofi/menu-theme.css;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;

  xdg.configFile."qt5ct/colors/darker.conf".source = ./configs/qt/darker.conf;
  xdg.configFile."qt6ct/colors/darker.conf".source = ./configs/qt/darker.conf;
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=/home/ale/.config/qt5ct/colors/darker.conf
    custom_palette=true
    standard_dialogs=default
    style=Fusion
    [Fonts]
    fixed="Sans Serif,12,-1,5,50,0,0,0,0,0"
    general="Sans Serif,12,-1,5,50,0,0,0,0,0"
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=/home/ale/.config/qt6ct/colors/darker.conf
    custom_palette=true
    standard_dialogs=default
    style=Fusion
    [Fonts]
    fixed="Sans Serif,12,-1,5,50,0,0,0,0,0"
    general="Sans Serif,12,-1,5,50,0,0,0,0,0"
  '';
  #};
  #home-manager.backupFileExtension = "backup";
}
