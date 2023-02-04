{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "Trevor Richards";
    userEmail = "trev@trevdev.ca";
    signing = {
      key = "0FB7D06B4A2AF07EAD5B1169183B63068AA1D206";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    maxCacheTtl = 60480000;
    sshKeys = ["FF9F589746CBDCE989E5C2D75928BCCDC1E7C015"];
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
    ];
    shortcut = "a";
    extraConfig = ''
      # vim-like pane resizing
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L
      bind -r C-l resize-pane -R

      # vim-like pane switching
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # and now unbind keys
      unbind Up
      unbind Down
      unbind Left
      unbind Right

      unbind C-Up
      unbind C-Down
      unbind C-Left
      unbind C-Right
    '';
  };

  xdg.configFile."systemd/mcron.env".text = with pkgs; ''
    PATH=$PATH:/home/trev/.nix-profile/bin
    XDG_DATA_HOME=/home/trev/.local/share
    GUILE_LOAD_PATH=${guile}/share/guile/3.0:'' +
      ''${guile}/share/guile/site/3.0:${guile}/share/guile/site:'' +
      ''${guile}/share/guile'';

  systemd.user = {
    services = {
      mcron = {
        Unit = {
          Description = "Run user cron jobs with GNU Mcron";
          Documentation = ["man:mcron(1)"];
        };
        Service = {
          Type = "forking";
          ExecStart = "${pkgs.mcron}/bin/mcron -d";
          EnvironmentFile = "/home/trev/.config/systemd/mcron.env";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };

  xdg.enable = true;

  home.file.".xinitrc".source = ./xinitrc;
  home.file.".aspell.conf".text = "dict-dir /home/trev/.nix-profile/lib/aspell";
  /* xdg.configFile."xmonad/xmonad.hs".source = config/xmonad/xmonad.hs;
  xdg.configFile."xmonad/Local".source = config/xmonad/Local; */
  xdg.configFile."xmobar/xmobar.hs".source = config/xmobar/xmobar.hs;
  xdg.configFile."i3".source = config/i3;
  xdg.configFile."kitty/kitty.conf".source = config/kitty/kitty.conf;
  xdg.configFile."msmtp/config".source = config/msmtp/config;
  xdg.configFile."vdirsyncer/config".source = config/vdirsyncer/config;
  xdg.configFile."khal/config".source = config/khal/config;
  xdg.configFile."khard/khard.conf".source = config/khard/khard.conf;
  xdg.configFile."picom/picom.conf".source = config/picom/picom.conf;
  xdg.configFile."zk".source = config/zk;
  xdg.configFile."dunst".source = config/dunst;
  home.file.".mbsyncrc".source = ./mbsyncrc;
  home.file.".notmuch-config".source = ./notmuch-config;
  xdg.dataFile."icons/envelope.png".source = ./local/share/icons/envelope.png;
  xdg.dataFile."scripts" = {
    recursive = true;
    source = ./local/share/scripts;
  };
  home.file.".local/bin/mailsync" = {
    source = local/bin/mailsync.scm;
    executable = true;
  };
  home.file.".cron".source = ./cron;
}
