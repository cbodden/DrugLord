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
        # Events 8-19: No event (60% chance of nothing happening)
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
