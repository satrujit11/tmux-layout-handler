Here's the README.md file in Markdown format:

# Tmux Layout Handler

This Bash script automates the creation of a Tmux session based on a configuration defined in a JSON file per project basis. It allows you to define the layout of your Tmux windows and panes, as well as the commands to be executed in each pane. Use it with [tmux-sessioniser](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer) to fully revolutinalize your development enviornment.

## Features

- Automatically creates Tmux windows and panes based on a JSON configuration file
- Supports horizontal and vertical pane splitting with customizable sizes
- Executes commands in each pane as specified in the configuration
- Handles the case where the Tmux windows already exist

## Prerequisites

- Bash
- Tmux
- jq (for parsing JSON data)

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/satrujit11/tmux-layout-handler.git
   ```

2. Create a `tmux_layout.json` file in the same directory as the script, and define your Tmux layout configuration. Here's an example:

   ```json
   {
     "windows": [
       {
         "name": "terminals",
         "panes": [
           {
             "size": 60,
             "direction": "h",
             "cmd": "n"
           },
           {
             "size": 40,
             "direction": "v",
             "cmd": "neofetch"
           },
           {
             "cmd": "l"
           }
         ]
       },
       {
         "name": "neovim",
         "cmd": "n",
         "default": true
       },
       {
         "name": "extra-action",
         "cmd": "neofetch"
       }
     ]
   }
   ```

3. Run the script:

   ```bash
   ./tmux-layout-automation.sh
   ```

   The script will create the Tmux session based on the configuration in the `tmux_layout.json` file.

### Or

1. Move this script file to `/usr/local/bin/tmux_layout`

    ```bash
    sudo mv tmux-layout-handler/script.sh /usr/local/bin/tmux_layout
    ```

2. Now use `tmux_layout` to run it.

3. You can make automatic layout creation by executing this command in tmux by adding below line in the `.tmux.conf` file

    ```bash
    set-hook -g session-created 'run-shell "tmux-layout-handler"'
    ```

## Configuration

The configuration is defined in a JSON file named `tmux_layout.json`. The file should have the following structure:

```json
{
  "windows": [
    {
      "name": "window_name",
      "panes": [
        {
          "size": 60,
          "direction": "h",
          "cmd": "command_to_execute"
        },
        {
          "size": 40,
          "direction": "v",
          "cmd": "command_to_execute"
        },
        {
          "cmd": "command_to_execute"
        }
      ]
    },
    {
      "name": "another_window_name",
      "cmd": "command_to_execute",
      "default": true
    },
    {
      "name": "extra_window",
      "cmd": "command_to_execute"
    }
  ]
}
```

- `windows`: An array of window configurations.
- `name`: The name of the Tmux window.
- `panes`: An array of pane configurations within the window.
- `size`: The size of the pane (as a percentage of the window).
- `direction`: The direction of the pane split (`h` for horizontal, `v` for vertical).
- `cmd`: The command to be executed in the pane.
- `default`: If set to `true`, the window will be created as the active window.

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
