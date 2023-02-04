{ config, pkgs, lib, ... }:

let
  unstable = import <nixpkgs-unstable> {};

  base = with pkgs; [
    bat
    borgbackup
    borgmatic
    git
    graphite-gtk-theme
    guile_3_0
    khal
    kitty
    libqalculate
    mcron
    notify-desktop
    pandoc
    paper-icon-theme
    pass
    ranger
    sshfs
    texlive.combined.scheme-full
    unzip
    vdirsyncer
    wget
    xclip
  ];

  browsers = with pkgs; [ brave firefox ];

  chat = with pkgs; [
    tdesktop
    slack
    element-desktop
    discord
    weechat
  ];

  cli = with pkgs; [
    taskwarrior
    taskwarrior-tui
    timewarrior
    ncpamixer
    lazygit
    zk
  ];

  devel = with pkgs; [
    cabal-install
    cargo
    gcc
    gnumake
    fd
    haskellPackages.haskell-language-server
    haskellPackages.hoogle
    (haskellPackages.ghcWithPackages (hpkgs : [
      hpkgs.xmobar
      hpkgs.xmonad
      hpkgs.xmonad-contrib
    ]))
    marksman
    neovim
    nim
    nimlsp
    nodejs
    jdk18
    python39
    poppler
    ripgrep
    rnix-lsp
    rustc
    sumneko-lua-language-server
    unstable.helix
    yarn
  ];

  fonts = with pkgs; [
    carlito
    noto-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  mail = with pkgs; [ neomutt w3m isync msmtp notmuch khard urlscan ];

in with lib; {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openjdk-18+36"
    ];
  };
  home.packages = concatLists [ base browsers chat cli devel fonts mail ];
}
