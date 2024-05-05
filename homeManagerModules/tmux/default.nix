{ pkgs, config, lib, ... }:
let

  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    
    # search projects directory
    dirs=$(${pkgs.findutils}/bin/find $HOME/Projects -mindepth 1 -maxdepth 1 -type d)

    # append nix conf
    dirs=$(${pkgs.coreutils}/bin/echo $dirs | ${pkgs.coreutils}/bin/cat - <(${pkgs.coreutils}/bin/echo "/nixconf"))

    # append home dir
    dirs=$(${pkgs.coreutils}/bin/echo $dirs | ${pkgs.coreutils}/bin/cat - <(${pkgs.coreutils}/bin/echo "$HOME"))

    dirs=$(${pkgs.coreutils}/bin/echo $dirs | ${pkgs.gnused}/bin/sed "s|$HOME|~|g")

    selected=$(${pkgs.coreutils}/bin/echo $dirs | ${pkgs.coreutils}/bin/tr ' ' '\n' | ${pkgs.fzf}/bin/fzf)

    selected=$(${pkgs.coreutils}/bin/echo $selected | ${pkgs.gnused}/bin/sed "s|~|$HOME|g")

    selected=$(${pkgs.coreutils}/bin/echo $selected | ${pkgs.coreutils}/bin/printf "%q" $selected)

    if [[ -z $selected ]]; then
      exit 0
    fi

    session=$(${pkgs.coreutils}/bin/basename $selected | ${pkgs.gnused}/bin/sed "s|\.|_|g")
    session=$(${pkgs.coreutils}/bin/echo $session | ${pkgs.coreutils}/bin/printf "%q" $session | ${pkgs.gnused}/bin/sed "s|\.|_|g")

    ${pkgs.coreutils}/bin/echo "session: $session"
    ${pkgs.coreutils}/bin/echo "selected: $selected"

    tmux_running=$(${pkgs.toybox}/bin/pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
      ${pkgs.tmux}/bin/tmux new-session -s "$session" -c "$selected"
      exit 0
    fi

    has_session=$(${pkgs.tmux}/bin/tmux has-session -t "$session" 2> /dev/null) 

    if [[ -z $has_session ]]; then
      ${pkgs.tmux}/bin/tmux new-session -ds "$session" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
      ${pkgs.tmux}/bin/tmux attach -t "$session"
    else
      ${pkgs.tmux}/bin/tmux switch-client -t "$session"
    fi
     
  '';

in
{
  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };

  config = lib.mkIf config.tmux.enable {

    home.packages = with pkgs; [
      tmux-sessionizer
    ];

    programs.tmux.enable = true;

    home.file.".config/tmux" = {
      source = ./config;
      recursive = true;
    };

  };

}
