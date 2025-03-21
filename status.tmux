#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source plugin options
tmux source "${CWD}/options.conf"

# Define colors (from catppuccin macchiato)
BLACK="#24273a"
PINK="#f5bde6"
MAUVE="#c6a0f6"
LAVENDER="#b7bdf8"
GREEN="#a6da95"
BLUE="#8aadf4"
TEAL="#8bd5ca"
TEXT="#b8c0e0"
SUBTEXT="#6e738d"

# Status Options
tmux set -gq status-interval 1
tmux set -gq status-style "bg=default"
tmux set -gq status-bg "default"
tmux set -gq status-fg "$TEXT"
tmux set -gq status-left-length 200
tmux set -gq status-right-length 200

########################################
# Left status bar
# MODE | SESSION
########################################

# Initialize using user defined status-left
LS="$(tmux show-option -gqv @status-left)"

DISPLAY_MODE="$(tmux show-option -gqv @status_mode_indicator)"
if [[ $DISPLAY_MODE = "on" ]]; then
    # MODE: tmux-mode-indicator
    tmux set -gq @mode_indicator_prefix_mode_style "bold,bg=$TEAL,fg=$BLACK"
    tmux set -gq @mode_indicator_copy_mode_style   "bold,bg=$PINK,fg=$BLACK"
    tmux set -gq @mode_indicator_sync_mode_style   "bold,bg=$BLUE,fg=$BLACK"
    tmux set -gq @mode_indicator_empty_mode_style  "bold,bg=$MAUVE,fg=$BLACK"
    LS="$LS#{tmux_mode_indicator}"
fi

# SESSION: [icon] session name [separator]
SESSION_ICON="$(tmux show-option -gqv @status_session_icon)"
SESSION_SEP="$(tmux show-option -gqv @status_session_separator)"
LS="$LS #[fg=$MAUVE,bg=default,bold]$SESSION_ICON #S $SESSION_SEP  "

tmux set -gq status-left "$LS"

########################################
# Window status
########################################

# Window format
WINDOW_ICON="$(tmux show-option -gqv @status_window_icon)"
tmux set -gq window-status-format "#[fg=$SUBTEXT,bg=default,bold]$WINDOW_ICON #I:#W#F"

# Current window
CURR_WINDOW_ICON="$(tmux show-option -gqv @status_current_window_icon)"
tmux set -gq window-status-current-format "#[fg=$BLUE,bg=default,bold]$CURR_WINDOW_ICON #I:#W#F"

########################################
# Right status bar
# user defined plugins | [CUSTOM]
########################################

# Initialize using user defined status-right
RS="#[bold] $(tmux show-option -gqv @status-right)"

BUILD_SCRIPT="$(tmux show-option -gqv @status_right_script)"
RS="$RS$($CWD/scripts/build.sh)"

RS="#[fg=$TEXT,bg=default]$RS"

CUSTOM="$(tmux show-option -gqv @status_right_custom)"
RS="$RS$CUSTOM"

tmux set -gq status-right "$RS"

########################################
# Other styles
########################################

# Pane border and number indicator (inactive/active)
tmux set -gq pane-border-style "fg=$SUBTEXT,bg=default"
tmux set -gq pane-active-border-style "fg=$MAUVE,bg=default"
tmux set -gq display-panes-colour "$SUBTEXT"
tmux set -gq display-panes-active-colour "$MAUVE"

# Clock mode
tmux set -gq clock-mode-colour "$MAUVE"
tmux set -gq clock-mode-style 24

# Message
tmux set -gq message-style "fg=$MAUVE,bg=default"
tmux set -gq message-command-style "fg=$MAUVE,bg=default"
