#!/bin/bash

save_game() {
    {
        echo "MONEY=${MONEY}"
        echo "DEBT=${DEBT}"
        echo "DAY=${DAY}"
        echo "HEALTH=${HEALTH}"
        echo "REPUTATION=${REPUTATION}"
        echo "POLICE_HEAT=${POLICE_HEAT}"
        echo "CURRENT_CITY=${CURRENT_CITY}"
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
    } > drug_lord_save.txt
    
    green "Game saved!"
}

load_game() {
    if [ -f "drug_lord_save.txt" ]; then
        source drug_lord_save.txt
        green "Game loaded!"
    else
        red "No save file found!"
    fi
}