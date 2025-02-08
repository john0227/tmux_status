#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source plugin options
tmux source "${CWD}/options.conf" &> /dev/null

# Define colors (from catppuccin macchiato)
PINK="#f5bde6"
MAUVE="#c6a0f6"
LAVENDER="#b7bdf8"
GREEN="#a6da95"
BLUE="#8aadf4"
TEAL="#8bd5ca"
TEXT="#b8c0e0"
SUBTEXT="#6e738d"

# Status Options
tmux set -ogq status-interval 1
tmux set -ogq status-style "bg=default"
tmux set -ogq status-bg "default"
tmux set -ogq status-fg "$TEXT"

########################################
# Left status bar
# MODE | SESSION
########################################

LS="#[bold]"

# MODE: tmux-mode-indicator
tmux set -ogq @mode_indicator_prefix_mode_style "bg=$MAUVE,fg=black"
tmux set -ogq @mode_indicator_copy_mode_style   "bg=$PINK,fg=black"
tmux set -ogq @mode_indicator_sync_mode_style   "bg=$BLUE,fg=black"
tmux set -ogq @mode_indicator_empty_mode_style  "bg=$TEAL,fg=black"
LS="#{tmux_mode_indicator}"

# SESSION: [icon] session name [separator]
SESSION_ICON="$(tmux show-option -gqv @status_session_icon)"
SESSION_SEP="$(tmux show-option -gqv @status_session_separator)"
LS="$LS #[fg=$MAUVE,bg=default]$SESSION_ICON #S $SESSION_SEP  "

tmux set -g status-left "$LS"

########################################
# Window status
########################################

# Window format
WINDOW_ICON="$(tmux show-option -gqv @status_window_icon)"
tmux set -gq window-status-format "#[fg=$SUBTEXT,bg=default]$WINDOW_ICON #I:#W#F"

# Current window
CURR_WINDOW_ICON="$(tmux show-option -gqv @status_current_window_icon)"
tmux set -gq window-status-current-format "#[fg=$BLUE,bg=default]$CURR_WINDOW_ICON #I:#W#F"

########################################
# Right status bar
# BATTERY TIME DATE [CUSTOM]
########################################

RS="#[bold]"

BUILD_SCRIPT="$(tmux show-option -gqv @status_right_script)"
RS="$RS$($CWD/scripts/build.sh)"

RS="#[fg=$TEXT,bg=default]$RS"

CUSTOM="$(tmux show-option -gqv @status_right_custom)"
RS="$RS$CUSTOM"

tmux set -g status-right "$RS"

########################################
# Other styles
########################################

# Pane border and number indicator (inactive/active)
tmux set -ogq pane-border-style "fg=$SUBTEXT,bg=default"
tmux set -ogq pane-active-border-style "fg=$MAUVE,bg=default"
tmux set -ogq display-panes-colour "$SUBTEXT"
tmux set -ogq display-panes-active-colour "$MAUVE"

# Clock mode
tmux set -ogq clock-mode-colour "$MAUVE"
tmux set -ogq clock-mode-style 24

# Message
tmux set -ogq message-style "fg=$MAUVE,bg=default"
tmux set -ogq message-command-style "fg=$MAUVE,bg=default"

