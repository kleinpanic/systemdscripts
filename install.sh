#!/usr/bin/env bash

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
