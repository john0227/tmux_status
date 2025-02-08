#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

plugin_str="$(tmux show-option -gqv @status_right_plugins)"
IFS=',' read -r -a plugins <<< $plugin_str

RS=""
RS_SEP="$(tmux show-option -gqv @status_right_separator)"
for plugin in "${plugins[@]}"; do
    if [[ "$plugin" = "time" || "$plugin" = "date" ]]; then
        icon="$(tmux show-option -gqv @status_${plugin}_icon)"
        format="$(tmux show-option -gqv @status_${plugin}_format)"
        RS="$RS $RS_SEP $icon $format"
    elif [[ -f "${CWD}/${plugin}.sh" ]]; then
        RS="$RS $RS_SEP #(${CWD}/${plugin}.sh)"
    fi
done

echo "${RS:3}"

