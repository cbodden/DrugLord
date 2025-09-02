#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all library files
source "${SCRIPT_DIR}/lib/colors.sh"
source "${SCRIPT_DIR}/lib/data.sh"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/game.sh"
source "${SCRIPT_DIR}/lib/menus.sh"
source "${SCRIPT_DIR}/lib/save.sh"

# Main game loop
main() {
    clear_screen
    print_header

    # Initialize random starting city
    initialize_city

    echo "$(green "Welcome to Drug Lord!")"
    echo "$(dim "Build your criminal empire in the underground drug trade.")"
    echo "$(dim "Buy low, sell high, avoid the police, and stay alive!")"
    echo
    echo "$(cyan "Starting in: ${cities[${CURRENT_CITY}]}")"
    echo
    read -p "Press Enter to start your criminal career..."

    while [ "${GAME_OVER}" = false ]; do
        clear_screen
        print_header
        print_stats
        print_inventory
        show_menu

        read -p "Choose option (1-10): " choice

        # Validate input is a number
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            red "Error: Please enter a valid number between 1-10!"
            read -p "Press Enter to continue..."
            continue
        fi

        case $choice in
            1)
                clear_screen
                print_header
                print_stats
                print_inventory
                read -p "Press Enter to continue..."
                ;;
            2)
                clear_screen
                print_header
                print_market
                read -p "Press Enter to continue..."
                ;;
            3)
                clear_screen
                print_header
                buy_menu
                read -p "Press Enter to continue..."
                ;;
            4)
                clear_screen
                print_header
                sell_menu
                read -p "Press Enter to continue..."
                ;;
            5)
                clear_screen
                print_header
                travel_menu
                read -p "Press Enter to continue..."
                ;;
            6)
                clear_screen
                print_header
                hospital_menu
                read -p "Press Enter to continue..."
                ;;
            7)
                next_day
                check_game_over
                ;;
            8)
                save_game
                read -p "Press Enter to continue..."
                ;;
            9)
                load_game
                read -p "Press Enter to continue..."
                ;;
            10)
                echo "$(yellow "Thanks for playing Drug Lord!")"
                exit 0
                ;;
            *)
                red "Error: Invalid choice! Please select a number between 1-10."
                read -p "Press Enter to continue..."
                ;;
        esac
    done

    echo
    red "💀 GAME OVER! 💀"
    echo "$(bold "Final Stats:")"
    print_stats
    echo "$(dim "Thanks for playing Drug Lord!")"
}

# Run the game
main
