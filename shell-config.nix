{ config, pkgs, lib, ... }:

{
  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = with lib.strings; {
    SUDO_EDITOR = "nvim";
    EDITOR = "nvim";
    ZK_NOTEBOOK_DIR = "/home/trev/Notes";
    SSH_AUTH_SOCK = "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
    PATH = concatStringsSep ":" [
      "$PATH"
      "$HOME/.local/node/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.nimble/bin"
    ];
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      k = "khal calendar";
      kl = "khal list";
      ki = "khal interactive";
      la = "ls -al";
      ll = "ls -l";
      nixos-rebuild = "sudo nixos-rebuild switch";
      nm = "neomutt";
      nv = "nvim";
      r = "ranger";
      t = "task";
      lg = "lazygit";
      ti = "timew";
      tib = "timew billable";
      tm = "task mod";
      tu = "taskwarrior-tui";
      zke = "zk edit --interactive";
      zkl = "zk list --interactive";
    };
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    plugins = [];
    initExtra = ''
      bindkey -e
      autoload -Uz vcs_info
      precmd () { vcs_info }
      zstyle ':vcs_info:git:*' formats ' %F{green} %b%f'
      setopt prompt_subst

      envColor=blue
      if [ -n "$IN_NIX_SHELL" ]; then
        envColor=255
      fi

      PS1='%F{white}%3~/$vcs_info_msg_0_ %B%F{$envColor}λ%f%b '
    '';
    loginExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
        exec startx &>/dev/null 
      fi
    '';
  };
}
