#!/bin/bash

# Utility functions
clear_screen() {
    clear
}

initialize_city() {
    if [ -z "${CURRENT_CITY}" ]; then
        # Get random city from cities array
        local city_keys=($(printf '%s\n' "${!cities[@]}" | shuf))
        CURRENT_CITY=${city_keys[0]}
    fi
}

get_city_price() {
    local drug=$1
    local base_price=${base_prices[${drug}]}
    local multiplier=${city_price_multipliers[${CURRENT_CITY}]}

    # Calculate city-adjusted price (multiply by 100 for integer math, then divide)
    local adjusted_price=$(echo "scale=0; ${base_price} * ${multiplier}" | bc -l)
    echo ${adjusted_price%.*}  # Remove decimal if any
}

print_header() {
    echo
    bold "$(cyan "╔═══════════════════════════════════════════════════════╗")"
    bold "$(cyan "║                      DRUG LORD                        ║")"
    bold "$(cyan "║                  Terminal Edition                     ║")"
    bold "$(cyan "╚═══════════════════════════════════════════════════════╝")"
    echo
}

print_stats() {
    echo "$(bold "📊 CURRENT STATS:")"
    echo "🏙️ Location:    $(cyan "${cities[${CURRENT_CITY}]}")"
    echo "💰 Money:       $(green "${MONEY}")"
    echo "💸 Debt:        $(red "${DEBT}")"
    echo "📅 Day:         $(yellow "${DAY}")"
    echo "❤️ Health:      $(red "${HEALTH}")"
    echo "⭐ Reputation:  $(yellow "${REPUTATION}")"
    echo "🚔 Police Heat: $(red "${POLICE_HEAT}")"
    echo
}

print_inventory() {
    echo "$(bold "🎒 INVENTORY:")"
    for drug in "${!drugs[@]}"; do
        if [ "${drugs[$drug]}" -gt 0 ]; then
            echo "  ${drug_names[$drug]}: $(green "${drugs[$drug]}") units"
        fi
    done
    echo
}

print_market() {
    echo "$(bold "🏪 DRUG MARKET:")"
    for drug in "${!drug_prices[@]}"; do
        echo "  ${drug_names[$drug]}: $(yellow "${drug_prices[$drug]}") per unit"
    done
    echo
}
