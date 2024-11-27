#!/usr/bin/env bash

# Function to copy the daemon_starter script to /usr/local/bin
install_daemon_starter() {
    echo "Installing daemon_starter..."
    sudo cp "daemon_starter" "/usr/local/bin/daemon_starter"
    sudo chmod +x "/usr/local/bin/daemon_starter"
    echo "daemon_starter installed successfully."
}

# Function to create or copy the config file
create_config_file() {
    CONFIG_DIR="${HOME}/.config"
    CONFIG_FILE="${CONFIG_DIR}/daemon_starter.conf"
    DEFAULT_CONFIG="daemon_starter.conf"

    mkdir -p "$CONFIG_DIR"

    if [[ -f "$CONFIG_FILE" ]]; then
        echo "Config file already exists at $CONFIG_FILE"
        return
    fi

    echo "No config file found."

    while true; do
        read -p "Do you want to create your own config file? (Y/n): " config_choice
        config_choice=${config_choice:-Y}

        case "$config_choice" in
            [Yy]* )
                echo "Creating an empty config file with instructions..."
                echo "# Add your daemon configurations here in the format:" > "$CONFIG_FILE"
                echo "# program_name=command_to_run" >> "$CONFIG_FILE"
                echo "# Example: fehbg=feh --bg-scale /path/to/background.jpg" >> "$CONFIG_FILE"
                echo "Empty config file created at $CONFIG_FILE"
                break
                ;;
            [Nn]* )
                echo "Copying the default config file to $CONFIG_FILE"
                cp "$DEFAULT_CONFIG" "$CONFIG_FILE"
                echo "Default config file copied."
                break
                ;;
            * )
                echo "Invalid input. Please enter Y or n."
                ;;
        esac
    done
}

# Handling 'individual' argument
if [[ "$1" == "individual" ]]; then
    # Loop through each .sh file in the current directory, ignoring install.sh
    for script in *.sh; do
        script_name=$(basename "$script" .sh)
        
        # Skip the install script itself
        [[ "$script_name" == "install" ]] && continue

        # Prompt the user for each script
        while true; do
            read -p "Do you want to install $script_name? (Y/n): " answer
            answer=${answer:-Y}  # Default to 'Y' if the user presses Enter

            case "$answer" in
                [Yy]* )
                    # Copy the script to /usr/local/bin without the .sh extension
                    echo "Installing $script_name..."
                    sudo cp "$script" "/usr/local/bin/$script_name"
                    sudo chmod +x "/usr/local/bin/$script_name"
                    break
                    ;;
                [Nn]* )
                    echo "Skipping $script_name."
                    break
                    ;;
                * )
                    echo "Invalid input. Please enter Y or n."
                    ;;
            esac
        done
    done

    echo "Installation process complete."
    exit 0
fi

# Handling 'mass' argument
if [[ "$1" == "mass" ]]; then
    # Check for existing scripts in /usr/local/bin and prompt for deletion
    echo "Checking for existing scripts in /usr/local/bin..."

    for script in *.sh; do
        script_name=$(basename "$script" .sh)
        if [[ -f "/usr/local/bin/$script_name" ]]; then
            while true; do
                read -p "Do you want to remove $script_name from /usr/local/bin? (Y/n): " remove_answer
                remove_answer=${remove_answer:-Y}

                case "$remove_answer" in
                    [Yy]* )
                        echo "Removing $script_name..."
                        sudo rm "/usr/local/bin/$script_name"
                        echo "$script_name removed."
                        break
                        ;;
                    [Nn]* )
                        echo "Skipping $script_name."
                        break
                        ;;
                    * )
                        echo "Invalid input. Please enter Y or n."
                        ;;
                esac
            done
        fi
    done

    # Install the daemon_starter script
    install_daemon_starter

    # Handle the config file setup
    create_config_file

    echo "Mass installation complete."
    exit 0
fi

# Default message if no valid argument is provided
echo "Usage: ./install.sh [individual|mass]"
exit 1
