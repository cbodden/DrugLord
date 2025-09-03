#!/bin/bash

# Random Events System
# This file contains all random events that can occur during gameplay

# Main random event function
random_event() {
    local EVENT=$((RANDOM % 20))  # Increased to 20 for more events

    case ${EVENT} in
        0)
            found_money_event
            ;;
        1)
            robbery_event
            ;;
        2)
            health_boost_event
            ;;
        3)
            loan_shark_event
            ;;
        4)
            debt_payment_event
            ;;
        5)
            warehouse_fire_event
            ;;
        6)
            warehouse_raid_event
            ;;
        7)
            girlfriend_weed_event
            ;;
        8)
            snitch_event
            ;;
        9)
            market_flooded_event
            ;;
        # Events 10-19: No event (50% chance of nothing happening)
    esac
}

# Event 0: Found Money
found_money_event() {
    local BONUS=$((RANDOM % 500 + 100))
    MONEY=$((${MONEY} + ${BONUS}))
    green "💰 Found \$${BONUS} on the street!"
}

# Event 1: Got Robbed
robbery_event() {
    local LOSS=$((RANDOM % 200 + 50))
    if [ ${MONEY} -ge ${LOSS} ]
    then
        MONEY=$((${MONEY} - ${LOSS}))
        red "💸 Got robbed! Lost \$${LOSS}"
    fi
}

# Event 2: Health Boost
health_boost_event() {
    HEALTH=$((${HEALTH} + 10))
    if [ ${HEALTH} -gt 100 ]
    then
        HEALTH=100
    fi
    green "❤️  Feeling better! Health +10"
}

# Event 3: Loan Shark Demands
loan_shark_event() {
    DEBT=$((${DEBT} + 200))
    red "💳 Loan shark demands payment! Debt +\$200"
}

# Event 4: Debt Payment
debt_payment_event() {
    if [ ${DEBT} -gt 0 ]
    then
        local PAYMENT=$((RANDOM % 100 + 50))
        if [ ${PAYMENT} -gt ${DEBT} ]
        then
            PAYMENT=${DEBT}
        fi
        DEBT=$((${DEBT} - ${PAYMENT}))
        MONEY=$((${MONEY} - ${PAYMENT}))
        yellow "💸 Paid \$${PAYMENT} towards debt"
    fi
}

# Event 5: Warehouse Fire
warehouse_fire_event() {
    local city_name="${cities[${CURRENT_CITY}]}"
    red "🔥 Local warehouse burned down in ${city_name}!"
    yellow "Supply shortage causes drug prices to skyrocket!"
    
    # Select 1-3 random drugs to increase in price
    local num_drugs=$((RANDOM % 3 + 1))
    local affected_drugs=()
    
    # Get list of available drugs
    local drug_list=($(printf '%s\n' "${!drug_prices[@]}"))
    
    # Select random drugs
    for ((i=0; i<num_drugs; i++)); do
        local random_index=$((RANDOM % ${#drug_list[@]}))
        local selected_drug="${drug_list[${random_index}]}"
        
        # Avoid duplicates
        if [[ ! " ${affected_drugs[@]} " =~ " ${selected_drug} " ]]; then
            affected_drugs+=("${selected_drug}")
        fi
    done
    
    # Apply price increases
    for drug in "${affected_drugs[@]}"; do
        local current_price=${drug_prices[${drug}]}
        local multiplier=$(echo "scale=1; $((${RANDOM} % 22 + 11)) / 10" | bc -l)  # 1.1 to 3.3
        local new_price=$(echo "scale=0; ${current_price} * ${multiplier}" | bc -l)
        new_price=${new_price%.*}  # Remove decimal
        
        # Ensure minimum price increase
        if [ ${new_price} -le ${current_price} ]; then
            new_price=$((${current_price} + 1))
        fi
        
        drug_prices[${drug}]=${new_price}
        red "📈 ${drug_names[${drug}]}: \$${current_price} → \$${new_price}"
    done
}

# Event 6: Warehouse Raid
warehouse_raid_event() {
    local city_name="${cities[${CURRENT_CITY}]}"
    red "🚔 Cops raided local warehouse in ${city_name}!"
    yellow "Supply shortage causes drug prices to skyrocket!"
    
    # Select 1-3 random drugs to increase in price
    local num_drugs=$((RANDOM % 3 + 1))
    local affected_drugs=()
    
    # Get list of available drugs
    local drug_list=($(printf '%s\n' "${!drug_prices[@]}"))
    
    # Select random drugs
    for ((i=0; i<num_drugs; i++)); do
        local random_index=$((RANDOM % ${#drug_list[@]}))
        local selected_drug="${drug_list[${random_index}]}"
        
        # Avoid duplicates
        if [[ ! " ${affected_drugs[@]} " =~ " ${selected_drug} " ]]; then
            affected_drugs+=("${selected_drug}")
        fi
    done
    
    # Apply price increases
    for drug in "${affected_drugs[@]}"; do
        local current_price=${drug_prices[${drug}]}
        local multiplier=$(echo "scale=1; $((${RANDOM} % 22 + 11)) / 10" | bc -l)  # 1.1 to 3.3
        local new_price=$(echo "scale=0; ${current_price} * ${multiplier}" | bc -l)
        new_price=${new_price%.*}  # Remove decimal
        
        # Ensure minimum price increase
        if [ ${new_price} -le ${current_price} ]; then
            new_price=$((${current_price} + 1))
        fi
        
        drug_prices[${drug}]=${new_price}
        red "📈 ${drug_names[${drug}]}: \$${current_price} → \$${new_price}"
    done
}
# Event 7: Girlfriend Weed Incident
girlfriend_weed_event() {
    # Only trigger if player has weed in inventory
    if [ "${drugs[weed]}" -gt 0 ]; then
        local weed_amount=${drugs[weed]}
        drugs[weed]=0
        
        red "💔 Your girlfriend chopped up all your weed!"
        red "Lost ${weed_amount} units of 🌿 Weed"
        yellow "She said it was 'for your own good'..."
        
        # Add some reputation loss for being careless
        REPUTATION=$((${REPUTATION} - 5))
        if [ ${REPUTATION} -lt 0 ]; then
            REPUTATION=0
        fi
    fi
}

# Event 8: Snitch Event
snitch_event() {
    # Only trigger if player has reputation > 11
    if [ ${REPUTATION} -gt 11 ]; then
        echo
        red "🚨 A SNITCH HAS FOUND YOU! 🚨"
        echo
        yellow "A local informant has discovered your criminal activities!"
        yellow "He's threatening to go to the police unless you pay up..."
        echo
        
        # Calculate demand amount (10-25% of current money)
        local demand_percent=$((RANDOM % 16 + 10))  # 10-25%
        local demand_amount=$(echo "scale=0; ${MONEY} * ${demand_percent} / 100" | bc -l)
        demand_amount=${demand_percent%.*}  # Remove decimal
        
        # Ensure minimum demand
        if [ ${demand_amount} -lt 50 ]; then
            demand_amount=50
        fi
        
        # Calculate intimidation cost (10 + 0.2-0.4x reputation)
        local intimidation_multiplier=$(echo "scale=1; $((${RANDOM} % 3 + 2)) / 10" | bc -l)  # 0.2-0.4
        local intimidation_cost=$(echo "scale=0; 10 + ${REPUTATION} * ${intimidation_multiplier}" | bc -l)
        intimidation_cost=${intimidation_cost%.*}  # Remove decimal
        
        # Ensure minimum intimidation cost
        if [ ${intimidation_cost} -lt 10 ]; then
            intimidation_cost=10
        fi
        
        # Ensure intimidation doesn't exceed current reputation
        if [ ${intimidation_cost} -gt ${REPUTATION} ]; then
            intimidation_cost=${REPUTATION}
        fi
        
        printf "%s\n" \
            "$(bold "💰 PAY HIM OFF:")" \
            "$(dim "Cost: \$${demand_amount} (${demand_percent}% of your money)")" \
            "$(red "⚠️ Will increase police heat!")" "" \
            "$(bold "😤 INTIMIDATE HIM:")" \
            "$(dim "Cost: ${intimidation_cost} reputation points")" \
            "$(green "✅ No police heat increase")" "" \
            "Choose your response:" \
            "1. 💰 Pay him off (\$${demand_amount})" \
            "2. 😤 Intimidate him (${intimidation_cost} reputation)" ""
        
        read -p "Choose option (1-2): " choice
        
        # Validate input
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            red "Error: Please enter a valid number!"
            return
        fi
        
        case $choice in
            1)
                # Pay him off
                if [ ${MONEY} -ge ${demand_amount} ]; then
                    MONEY=$((${MONEY} - ${demand_amount}))
                    red "💰 You paid the snitch \$${demand_amount} to keep quiet"
                    
                    # Increase police heat
                    if [ ${POLICE_HEAT} -gt 0 ]; then
                        local heat_increase=$(echo "scale=0; ${POLICE_HEAT} * 0.5" | bc -l)
                        heat_increase=${heat_increase%.*}
                        if [ ${heat_increase} -lt 1 ]; then
                            heat_increase=1
                        fi
                        POLICE_HEAT=$((${POLICE_HEAT} + ${heat_increase}))
                        red "🚔 Police heat increased by ${heat_increase} (now ${POLICE_HEAT})"
                    else
                        local heat_increase=$((RANDOM % 21 + 10))  # 10-30
                        POLICE_HEAT=${heat_increase}
                        red "🚔 Police heat increased to ${POLICE_HEAT}"
                    fi
                else
                    red "Error: You don't have enough money! The snitch goes to the police anyway!"
                    local heat_increase=$((RANDOM % 21 + 10))  # 10-30
                    POLICE_HEAT=${heat_increase}
                    red "🚔 Police heat increased to ${POLICE_HEAT}"
                fi
                ;;
            2)
                # Intimidate him
                if [ ${REPUTATION} -ge ${intimidation_cost} ]; then
                    REPUTATION=$((${REPUTATION} - ${intimidation_cost}))
                    green "😤 You successfully intimidated the snitch!"
                    green "Lost ${intimidation_cost} reputation points (now ${REPUTATION})"
                    yellow "The snitch backed down and won't talk to the police"
                else
                    red "Error: You don't have enough reputation to intimidate him!"
                    red "The snitch goes to the police anyway!"
                    local heat_increase=$((RANDOM % 21 + 10))  # 10-30
                    POLICE_HEAT=${heat_increase}
                    red "🚔 Police heat increased to ${POLICE_HEAT}"
                fi
                ;;
            *)
                red "Error: Invalid choice! The snitch goes to the police anyway!"
                local heat_increase=$((RANDOM % 21 + 10))  # 10-30
                POLICE_HEAT=${heat_increase}
                red "🚔 Police heat increased to ${POLICE_HEAT}"
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    fi
}

# Event 9: Market Flooded Event
market_flooded_event() {
    local city_name="${cities[${CURRENT_CITY}]}"
    green "🚢 A ship came in and now the market is flooded with drugs!"
    yellow "Supply glut causes drug prices to plummet in ${city_name}!"
    
    # Select 1-4 random drugs to decrease in price
    local num_drugs=$((RANDOM % 4 + 1))
    local affected_drugs=()
    
    # Get list of available drugs
    local drug_list=($(printf '%s\n' "${!drug_prices[@]}"))
    
    # Select random drugs
    for ((i=0; i<num_drugs; i++)); do
        local random_index=$((RANDOM % ${#drug_list[@]}))
        local selected_drug="${drug_list[${random_index}]}"
        
        # Avoid duplicates
        if [[ ! " ${affected_drugs[@]} " =~ " ${selected_drug} " ]]; then
            affected_drugs+=("${selected_drug}")
        fi
    done
    
    # Apply price decreases
    for drug in "${affected_drugs[@]}"; do
        local current_price=${drug_prices[${drug}]}
        local multiplier=$(echo "scale=2; $((${RANDOM} % 51 + 25)) / 100" | bc -l)  # 0.25 to 0.75
        local new_price=$(echo "scale=0; ${current_price} * ${multiplier}" | bc -l)
        new_price=${new_price%.*}  # Remove decimal
        
        # Ensure minimum price of $1
        if [ ${new_price} -lt 1 ]; then
            new_price=1
        fi
        
        # Ensure price actually decreased
        if [ ${new_price} -ge ${current_price} ]; then
            new_price=$((${current_price} - 1))
            if [ ${new_price} -lt 1 ]; then
                new_price=1
            fi
        fi
        
        drug_prices[${drug}]=${new_price}
        green "📉 ${drug_names[${drug}]}: \$${current_price} → \$${new_price}"
    done
}
