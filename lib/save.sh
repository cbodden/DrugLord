#!/bin/bash

save_game() {
    # Create backup of existing save file
    if [ -f "druglord_save.txt" ]; then
        cp druglord_save.txt druglord_save.txt.backup
    fi
    
    # Save game state
    {
        echo "MONEY=${MONEY}"
        echo "DEBT=${DEBT}"
        echo "DAY=${DAY}"
        echo "HEALTH=${HEALTH}"
        echo "REPUTATION=${REPUTATION}"
        echo "POLICE_HEAT=${POLICE_HEAT}"
        echo "CURRENT_CITY=${CURRENT_CITY}"
        echo "SAVINGS=${SAVINGS}"
        echo "SAVINGS_INTEREST_RATE=${SAVINGS_INTEREST_RATE}"
        echo "LOAN_AMOUNT=${LOAN_AMOUNT}"
        echo "LOAN_INTEREST_RATE=${LOAN_INTEREST_RATE}"
        echo "LOAN_DAYS_LEFT=${LOAN_DAYS_LEFT}"
        for drug in "${!drugs[@]}"; do
            echo "drugs[${drug}]=${drugs[${drug}]}"
        done
        for drug in "${!drug_prices[@]}"; do
            echo "drug_prices[${drug}]=${drug_prices[${drug}]}"
        done
        for drug in "${!drug_volatility[@]}"; do
            echo "drug_volatility[${drug}]=${drug_volatility[${drug}]}"
        done
        for drug in "${!base_prices[@]}"; do
            echo "base_prices[${drug}]=${base_prices[${drug}]}"
        done
        for city in "${!city_travel_costs[@]}"; do
            echo "city_travel_costs[${city}]=${city_travel_costs[${city}]}"
        done
        for city in "${!base_travel_costs[@]}"; do
            echo "base_travel_costs[${city}]=${base_travel_costs[${city}]}"
        done
        for city in "${!travel_cost_volatility[@]}"; do
            echo "travel_cost_volatility[${city}]=${travel_cost_volatility[${city}]}"
        done
    } > druglord_save.txt
    
    # Verify save file was created successfully
    if [ -f "druglord_save.txt" ] && [ -s "druglord_save.txt" ]; then
        green "Game saved successfully!"
    else
        red "Error: Failed to save game!"
        # Restore backup if save failed
        if [ -f "druglord_save.txt.backup" ]; then
            mv druglord_save.txt.backup druglord_save.txt
            red "Restored previous save file."
        fi
    fi
}

load_game() {
    if [ -f "druglord_save.txt" ]; then
        # Check if save file is not empty
        if [ ! -s "druglord_save.txt" ]; then
            red "Error: Save file is corrupted (empty)!"
            return 1
        fi
        
        # Try to load the save file
        if source druglord_save.txt 2>/dev/null; then
            # Validate critical variables exist
            if [ -z "${MONEY}" ] || [ -z "${DEBT}" ] || [ -z "${DAY}" ]; then
                red "Error: Save file is corrupted (missing critical data)!"
                return 1
            fi
            green "Game loaded successfully!"
        else
            red "Error: Failed to load save file!"
            # Try to restore from backup
            if [ -f "druglord_save.txt.backup" ]; then
                red "Attempting to restore from backup..."
                if source druglord_save.txt.backup 2>/dev/null; then
                    green "Backup save file loaded successfully!"
                else
                    red "Backup save file is also corrupted!"
                    return 1
                fi
            else
                red "No backup save file available!"
                return 1
            fi
        fi
    else
        red "No save file found!"
    fi
}