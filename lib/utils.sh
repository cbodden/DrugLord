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

    # Calculate city-adjusted price with error handling
    local adjusted_price=$(echo "scale=0; ${base_price} * ${multiplier}" | bc -l 2>/dev/null)
    if [ -z "$adjusted_price" ] || [ "$adjusted_price" = "0" ]; then
        red "Error: Price calculation failed for ${drug}!"
        echo "0"
        return 1
    fi
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
    
    # Banking information
    if [ ${SAVINGS} -gt 0 ] || [ ${LOAN_AMOUNT} -gt 0 ]; then
        echo "🏦 Banking:"
        if [ ${SAVINGS} -gt 0 ]; then
            echo "  💰 Savings:     $(green "${SAVINGS}")"
        fi
        if [ ${LOAN_AMOUNT} -gt 0 ]; then
            echo "  💳 Loan:        $(red "${LOAN_AMOUNT}") (${LOAN_DAYS_LEFT} days)"
        fi
    fi
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
    printf "%s\n" \
    "$(bold "🏪 DRUG MARKET:")" \
    "$(dim "💹 Current market prices in ${cities[${CURRENT_CITY}]}:")" ""

    # Create columnar format
    printf "%-3s %-13s %-12s %-10s %-15s\n" "No." "Drug" "Price/Unit" "Base Price" "Trend"
    printf "%-3s %-13s %-12s %-10s %-15s\n" "---" "----" "----------" "----------" "-----"

    local i=1
    for drug in "${!drug_prices[@]}"; do
        local current_price=${drug_prices[$drug]}
        local base_price=${base_prices[$drug]}
        local trend=""

        # Add price trend indicator
        if [ $current_price -gt $base_price ]; then
            trend="$(red "📈 High")"
        elif [ $current_price -lt $base_price ]; then
            trend="$(green "📉 Low")"
        else
            trend="$(yellow "➡️ Avg")"
        fi

        printf "%-3s %-15s %-12s %-10s %-15s\n" \
            "${i}." "${drug_names[$drug]}" "\$${current_price}" "\$${base_price}" "${trend}"
        i=$((i + 1))
    done

    echo
    printf "%s\n" "$(dim "💡 Prices fluctuate based on city multipliers and market volatility")" ""
}
