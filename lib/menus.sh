#!/bin/bash

show_menu() {
    printf "%s\n" \
        "$(bold "🎮 MAIN MENU:")" \
        "1. 📊 View Stats & Inventory" \
        "2. 🏪 View Market Prices" \
        "3. 🛒 Buy Drugs" \
        "4. 💰 Sell Drugs" \
        "5. ✈️ Travel to Another City" \
        "6. 🏥 Hospital (Heal)" \
        "7. ⏰ Next Day" \
        "8. 💾 Save Game" \
        "9. 📁 Load Game" \
        "10. ❌ Quit" ""
}

buy_menu() {
    # Fluctuate prices each time you view the menu
    fluctuate_prices

    printf "%s\n" \
    "$(bold "🛒 BUY DRUGS:")" \
    "$(dim "💹 Prices fluctuate in real-time!")" ""

    # Create columnar format
    printf "%-3s %-13s %-12s %-8s\n" "No." "Drug" "Price/Unit" "Trend"
    printf "%-3s %-13s %-12s %-8s\n" "---" "----" "----------" "-----"

    local i=1
    local drug_list=()

    for drug in "${!drug_prices[@]}"; do
        local CURRENT_PRICE=${drug_prices[${drug}]}
        local BASE_PRICE=${base_prices[${drug}]}
        local PRICE_INDICATOR=""

        # Add price trend indicator
        if [ ${CURRENT_PRICE} -gt ${BASE_PRICE} ]; then
            PRICE_INDICATOR="$(red "📈")"
        elif [ ${CURRENT_PRICE} -lt ${BASE_PRICE} ]; then
            PRICE_INDICATOR="$(green "📉")"
        else
            PRICE_INDICATOR="$(yellow "➡️")"
        fi

        printf "%-3s %-15s %-12s %-8s\n" \
            "${i}." \
            "${drug_names[${drug}]}" \
            "${CURRENT_PRICE}" \
            "${PRICE_INDICATOR}"
        drug_list+=("${drug}")
        i=$((${i} + 1))
    done

    printf "%s\n" "" "${i}. Back to main menu" ""

    read -p "Choose drug (1-${i}): " choice

    # Validate input is a number
    if ! [[ "${choice}" =~ ^[0-9]+$ ]]; then
        red "Error: Please enter a valid number!"
        return
    fi

    if [ "${choice}" -ge 1 ] && [ "${choice}" -lt ${i} ]; then
        local SELECTED_DRUG=${drug_list[$((choice - 1))]}
        read -p "How many units? " quantity

        if [[ "${quantity}" =~ ^[0-9]+$ ]] && [ "${quantity}" -gt 0 ]; then
            buy_drug "${SELECTED_DRUG}" "${quantity}"
        else
            red "Error: Invalid quantity! Please enter a positive number."
        fi
    fi
}

sell_menu() {
    printf "%s\n" \
    "$(bold "💰 SELL DRUGS:")" \
    "$(dim "💹 Current sale prices (base price + random profit/loss):")" ""

    # Show current sale prices for all drugs
    printf "%-3s %-11s %-12s %-8s %-10s\n" "No." "Drug" "Sale Price" "Available" "Trend"
    printf "%-3s %-11s %-12s %-8s %-10s\n" "---" "----" "----------" "---------" "-----"

    local i=1
    local drug_list=()

    for drug in "${!drugs[@]}"; do
        local current_price=${drug_prices[$drug]}
        local trend=""

        # Add price trend indicator (similar to buy menu)
        if [ $current_price -gt ${base_prices[$drug]} ]; then
            trend="$(red "📈 High")"
        elif [ $current_price -lt ${base_prices[$drug]} ]; then
            trend="$(green "📉 Low")"
        else
            trend="$(yellow "➡️ Avg")"
        fi

        local available="${drugs[$drug]}"
        #if [ $available -eq 0 ]; then
        #    available="$(dim "0")"
        #fi

        printf "%-3s %-13s %-12s %-9s %-10s\n" \
            "${i}." "${drug_names[$drug]}" "\$${current_price}" "${available}" "${trend}"
            ##"${i}." "${drug_names[$drug]}" "\$${current_price}" "${trend}" "${available}"
        drug_list+=("$drug")
        i=$((i + 1))
    done

    echo
    printf "%s\n" "$(bold "Available for sale:")" ""

    local sell_i=1
    local sell_drug_list=()

    for drug in "${!drugs[@]}"; do
        if [ "${drugs[$drug]}" -gt 0 ]; then
            printf "%s\n" \
                "$sell_i. ${drug_names[$drug]} - ${drugs[$drug]} units available"
            sell_drug_list+=("$drug")
            sell_i=$((sell_i + 1))
        fi
    done

    if [ $sell_i -eq 1 ]; then
        red "Error: No drugs available to sell!"
        return
    fi

    printf "%s\n" "$sell_i. Back to main menu" ""

    read -p "Choose drug (1-$sell_i): " choice

    # Validate input is a number
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        red "Error: Please enter a valid number!"
        return
    fi

    if [ "$choice" -ge 1 ] && [ "$choice" -lt $sell_i ]; then
        local selected_drug=${sell_drug_list[$((choice - 1))]}
        read -p "How many units? " quantity

        if [[ "$quantity" =~ ^[0-9]+$ ]] && [ "$quantity" -gt 0 ]; then
            sell_drug "$selected_drug" "$quantity"
        else
            red "Error: Invalid quantity! Please enter a positive number."
        fi
    fi
}

travel_menu() {
    # Fluctuate travel costs each time you view the menu
    fluctuate_travel_costs

    printf "%s\n" \
        "$(bold "✈️ TRAVEL TO ANOTHER CITY:")" \
        "$(dim "Current location: ${cities[${CURRENT_CITY}]}")" \
        "$(dim "✈️ Travel costs fluctuate in real-time!")" "" \
        "Available cities:" ""

    # Create columnar format
    printf "%-3s %-16s %-12s %-15s\n" "No." "City" "Travel Cost" "Price Level"
    printf "%-3s %-16s %-12s %-15s\n" "---" "----" "-----------" "-----------"

    local i=1
    local city_list=()

    for city in "${!cities[@]}"; do
        if [ "${city}" != "${CURRENT_CITY}" ]; then
            local travel_cost=${city_travel_costs[${city}]}
            local price_multiplier=${city_price_multipliers[${city}]}
            local price_indicator=""

            # Add price indicator
            if (( $(echo "${price_multiplier} > 1.1" | bc -l) )); then
                price_indicator="$(red "📈 Expensive")"
            elif (( $(echo "${price_multiplier} < 0.9" | bc -l) )); then
                price_indicator="$(green "📉 Cheap")"
            else
                price_indicator="$(yellow "➡️ Average")"
            fi

            printf "%-3s %-18s %-12s %-15s\n" \
                "${i}." "${cities[${city}]}" "${travel_cost}" "${price_indicator}"
            city_list+=("${city}")
            i=$((${i} + 1))
        fi
    done

    echo
    echo "${i}. Back to main menu"
    echo

    read -p "Choose city (1-${i}): " choice

    # Validate input is a number
    if ! [[ "${choice}" =~ ^[0-9]+$ ]]; then
        red "Error: Please enter a valid number!"
        return
    fi

    if [ "${choice}" -ge 1 ] && [ "${choice}" -lt ${i} ]; then
        local selected_city=${city_list[$((choice - 1))]}
        local travel_cost=${city_travel_costs[${selected_city}]}

        if [ ${MONEY} -ge ${travel_cost} ]; then
            MONEY=$((${MONEY} - ${travel_cost}))
            CURRENT_CITY=${selected_city}

            # Update prices for new city
            update_prices

            green "Traveled to ${cities[${CURRENT_CITY}]} for \$${travel_cost}!"
            echo "$(dim "Prices have been adjusted for the new city.")"
        else
            red "Error: Insufficient funds! You need \$${travel_cost} but only have \$${MONEY}"
        fi
    fi
}

hospital_menu() {
    # Check if player needs healing
    if [ ${HEALTH} -ge 100 ]; then
        green "You're already at full health (${HEALTH})! No need for medical attention."
        return
    fi

    # Calculate healing cost based on current health
    local health_deficit=$((100 - HEALTH))
    local base_cost=50
    local cost_per_point=10
    local emergency_fee=0
    
    # Add emergency fee for critical health
    if [ ${HEALTH} -lt 20 ]; then
        emergency_fee=200
    elif [ ${HEALTH} -lt 50 ]; then
        emergency_fee=100
    fi
    
    local total_cost=$((base_cost + (health_deficit * cost_per_point) + emergency_fee))
    
    printf "%s\n" \
        "$(bold "🏥 HOSPITAL - EMERGENCY CARE:")" \
        "$(dim "Current health: ${HEALTH}/100")" \
        "$(dim "Health deficit: ${health_deficit} points")" "" \
        "$(bold "Treatment Options:")" \
        "1. 💉 Full Treatment - Restore to 100 health" \
        "2. 🩹 Partial Treatment - Restore 25 health points" \
        "3. 💊 Basic Treatment - Restore 10 health points" \
        "4. 🚪 Leave Hospital" ""

    # Calculate costs for different treatments
    local full_cost=${total_cost}
    local partial_cost=$((total_cost / 4))
    local basic_cost=$((total_cost / 10))
    
    # Ensure minimum costs
    if [ ${partial_cost} -lt 25 ]; then
        partial_cost=25
    fi
    if [ ${basic_cost} -lt 10 ]; then
        basic_cost=10
    fi

    printf "%s\n" \
        "$(bold "Treatment Costs:")" \
        "💉 Full Treatment: \$${full_cost}" \
        "🩹 Partial Treatment: \$${partial_cost}" \
        "💊 Basic Treatment: \$${basic_cost}" ""

    # Show emergency fee if applicable
    if [ ${emergency_fee} -gt 0 ]; then
        red "⚠️ Emergency fee applies due to critical health condition!"
    fi

    read -p "Choose treatment (1-4): " choice

    # Validate input is a number
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        red "Error: Please enter a valid number!"
        return
    fi

    case $choice in
        1)
            if [ ${MONEY} -ge ${full_cost} ]; then
                MONEY=$((${MONEY} - ${full_cost}))
                HEALTH=100
                green "💉 Full treatment complete! Health restored to 100."
                green "Cost: \$${full_cost}"
            else
                red "Error: Insufficient funds! You need \$${full_cost} but only have \$${MONEY}"
            fi
            ;;
        2)
            if [ ${MONEY} -ge ${partial_cost} ]; then
                MONEY=$((${MONEY} - ${partial_cost}))
                HEALTH=$((${HEALTH} + 25))
                if [ ${HEALTH} -gt 100 ]; then
                    HEALTH=100
                fi
                green "🩹 Partial treatment complete! Health increased by 25 points."
                green "Current health: ${HEALTH}/100"
                green "Cost: \$${partial_cost}"
            else
                red "Error: Insufficient funds! You need \$${partial_cost} but only have \$${MONEY}"
            fi
            ;;
        3)
            if [ ${MONEY} -ge ${basic_cost} ]; then
                MONEY=$((${MONEY} - ${basic_cost}))
                HEALTH=$((${HEALTH} + 10))
                if [ ${HEALTH} -gt 100 ]; then
                    HEALTH=100
                fi
                green "💊 Basic treatment complete! Health increased by 10 points."
                green "Current health: ${HEALTH}/100"
                green "Cost: \$${basic_cost}"
            else
                red "Error: Insufficient funds! You need \$${basic_cost} but only have \$${MONEY}"
            fi
            ;;
        4)
            yellow "Leaving hospital. Take care of your health!"
            ;;
        *)
            red "Error: Invalid choice! Please select 1-4."
            ;;
    esac
}
