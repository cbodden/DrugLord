#!/bin/bash

show_menu() {
    echo "$(bold "🎮 MAIN MENU:")"
    echo "1. 📊 View Stats & Inventory"
    echo "2. 🏪 View Market Prices"
    echo "3. 🛒 Buy Drugs"
    echo "4. 💰 Sell Drugs"
    echo "5. ✈️ Travel to Another City"
    echo "6. ⏰ Next Day"
    echo "7. 💾 Save Game"
    echo "8. 📁 Load Game"
    echo "9. ❌ Quit"
    echo
}

buy_menu() {
    # Fluctuate prices each time you view the menu
    fluctuate_prices
    
    echo "$(bold "🛒 BUY DRUGS:")"
    echo "$(dim "💹 Prices fluctuate in real-time!")"
    echo
    
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
    
    echo
    echo "${i}. Back to main menu"
    echo
    
    read -p "Choose drug (1-${i}): " choice
    
    if [ "${choice}" -ge 1 ] && [ "${choice}" -lt ${i} ]; then
        local SELECTED_DRUG=${drug_list[$((choice - 1))]}
        read -p "How many units? " quantity
        
        if [[ "${quantity}" =~ ^[0-9]+$ ]] && [ "${quantity}" -gt 0 ]; then
            buy_drug "${SELECTED_DRUG}" "${quantity}"
        else
            red "Invalid quantity!"
        fi
    fi
}

sell_menu() {
    echo "$(bold "💰 SELL DRUGS:")"
    local i=1
    local drug_list=()
    
    for drug in "${!drugs[@]}"; do
        if [ "${drugs[$drug]}" -gt 0 ]; then
            echo "$i. ${drug_names[$drug]} - ${drugs[$drug]} units available"
            drug_list+=("$drug")
            i=$((i + 1))
        fi
    done
    
    if [ $i -eq 1 ]; then
        red "No drugs to sell!"
        return
    fi
    
    echo "$i. Back to main menu"
    echo
    
    read -p "Choose drug (1-$i): " choice
    
    if [ "$choice" -ge 1 ] && [ "$choice" -lt $i ]; then
        local selected_drug=${drug_list[$((choice - 1))]}
        read -p "How many units? " quantity
        
        if [[ "$quantity" =~ ^[0-9]+$ ]] && [ "$quantity" -gt 0 ]; then
            sell_drug "$selected_drug" "$quantity"
        else
            red "Invalid quantity!"
        fi
    fi
}

travel_menu() {
    echo "$(bold "✈️ TRAVEL TO ANOTHER CITY:")"
    echo "$(dim "Current location: ${cities[${CURRENT_CITY}]}")"
    echo
    echo "Available cities:"
    
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
            
            echo "${i}. ${cities[${city}]} - \$${travel_cost} travel cost ${price_indicator}"
            city_list+=("${city}")
            i=$((${i} + 1))
        fi
    done
    
    echo "${i}. Back to main menu"
    echo
    
    read -p "Choose city (1-${i}): " choice
    
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
            red "Not enough money! You need \$${travel_cost} but only have ${MONEY}"
        fi
    fi
}
