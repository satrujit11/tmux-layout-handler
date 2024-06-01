#!/bin/bash

execute_command() {
  local window_name=$1
  local cmd=$(echo $json_data | jq -r ".windows[] | select(.name == \"$window_name\") | .cmd")
  if [[ -n "$cmd" && "$cmd" != "null" ]]; then
    tmux send-keys -t "$window_name" "$cmd" Enter
  fi
}

create_window() {
  local window_name=$1
  local default=$(echo $json_data | jq -r ".windows[] | select(.name == \"$window_name\") | .default")
  if [[ -n "$default" && "$default" != "null" && "$default" == true ]]; then
    tmux neww -n "$window_name"
  else
    tmux neww -d -n "$window_name"
  fi
}

create_tmux_window() {
  windows=$(echo $json_data | jq -r '.windows[].name')
  if tmux list-windows | grep -q "$windows"; then
    exit 0
  fi
  first_window=true
  for window in $windows; do
    if [[ "$first_window" == true ]]; then
      if tmux list-windows | grep -q "^0:"; then
        tmux rename-window -t 0 "$window"
        execute_command "$window"
      else
        create_window "$window"
        execute_command "$window"
      fi
      local panes=$(echo $json_data | jq -r ".windows[] | select(.name == \"$window\") | .panes")
      if [[ -n "$panes" && "$panes" != "null" ]]; then
        create_tmux_pane "$window"
      fi
      first_window=false
    else
      create_window "$window"
      execute_command "$window"
      local panes=$(echo $json_data | jq -r ".windows[] | select(.name == \"$window\") | .panes")
      if [[ -n "$panes" && "$panes" != "null" ]]; then
        create_tmux_pane "$window"
      fi
    fi
  done
}


create_tmux_pane(){
  local window_name=$1
  local total_number_of_pane=$(echo $json_data | jq ".windows[] | select(.name == \"$window_name\") | .panes | length")
  for i in $(seq 0 $((total_number_of_pane - 1))); do
    local pane=$(echo $json_data | jq ".windows[] | select(.name == \"$window_name\") | .panes[$i]")
    local cmd=$(echo $pane | jq -r '.cmd')

    if [[ $i == $((total_number_of_pane -1)) && -n $cmd && $cmd != "null" ]]; then
      tmux send-keys -t "$window_name.$i" "$cmd" Enter
    else
      local size=$(echo $pane | jq -r '.size')
      local original_direction=$(echo $pane | jq -r '.direction')
      if [[ -z "$original_direction" || "$original_direction" == "null" ]]; then
        direction="v"
      elif [[ "$original_direction" == "vertical" || "$original_direction" == "v" ]]; then
        direction="v"
      elif [[ "$original_direction" == "horizontal" || "$original_direction" == "h" ]]; then
        direction="h"
      else
        direction="$original_direction"
      fi

      if [[ -n "$size" && "$size" != "null" ]]; then
        remaining_size=$((100 - size))
        tmux split-window -"$direction" -l $remaining_size%
      else
        tmux split-window -"$direction"
      fi
      if [[ -n $cmd && $cmd != "null" ]]; then
        tmux send-keys -t "$window_name.$i" "$cmd" Enter
      fi
    fi
  done
}

if [ -f "tmux_layout.json" ]; then
  json_data=$(cat tmux_layout.json)
  create_tmux_window
else
  exit 0
fi
