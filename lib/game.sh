#!/bin/bash

# Game mechanics
update_prices() {
    # Randomly fluctuate prices with volatility and city adjustments
    for drug in "${!drug_prices[@]}"; do
        local volatility=${drug_volatility[$drug]}
        local base_price=${base_prices[$drug]}
        local city_multiplier=${city_price_multipliers[${CURRENT_CITY}]}

        # Calculate city-adjusted base price
        local city_base_price=$( \
            echo "scale=0; ${base_price} * ${city_multiplier}" | bc -l)
        city_base_price=${city_base_price%.*}

        # Calculate change based on volatility
        local max_change=$((volatility * 2))
        local change=$((RANDOM % (max_change + 1) - volatility))

        # Add some market pressure (prices tend to return to city base)
        local market_pressure=$(( \
            (city_base_price - drug_prices[$drug]) / 10 ))
        change=$((change + market_pressure))

        local new_price=$((${drug_prices[$drug]} + change))

        # Keep prices within reasonable bounds
        local min_price=$((city_base_price / 2))
        local max_price=$((city_base_price * 3))

        if [ $new_price -lt $min_price ]
        then
            new_price=$min_price
        elif [ $new_price -gt $max_price ]
        then
            new_price=$max_price
        fi

        drug_prices[$drug]=$new_price
    done
}

fluctuate_prices() {
    # Light fluctuation for real-time updates
    for drug in "${!drug_prices[@]}"; do
        local volatility=${drug_volatility[$drug]}
        local change=$((RANDOM % (volatility + 1) - (volatility / 2)))
        local new_price=$((${drug_prices[$drug]} + change))

        # Keep within bounds
        local base_price=${base_prices[$drug]}
        local min_price=$((base_price / 2))
        local max_price=$((base_price * 3))

        if [ $new_price -lt $min_price ]
        then
            new_price=$min_price
        elif [ $new_price -gt $max_price ]
        then
            new_price=$max_price
        fi

        drug_prices[$drug]=$new_price
    done
}

fluctuate_travel_costs() {
    # Fluctuate travel costs based on volatility
    for city in "${!city_travel_costs[@]}"; do
        local volatility=${travel_cost_volatility[$city]}
        local base_cost=${base_travel_costs[$city]}

        # Calculate change based on volatility
        local max_change=$((volatility * 2))
        local change=$((RANDOM % (max_change + 1) - volatility))

        # Add some market pressure (costs tend to return to base)
        local market_pressure=$(( \
            (base_cost - city_travel_costs[$city]) / 8 ))
        change=$((change + market_pressure))

        local new_cost=$((${city_travel_costs[$city]} + change))

        # Keep costs within reasonable bounds (50% to 200% of base cost)
        local min_cost=$((base_cost / 2))
        local max_cost=$((base_cost * 2))

        if [ $new_cost -lt $min_cost ]
        then
            new_cost=$min_cost
        elif [ $new_cost -gt $max_cost ]
        then
            new_cost=$max_cost
        fi

        city_travel_costs[$city]=$new_cost
    done
}

buy_drug() {
    local DRUG=$1
    local QUANTITY=$2

    if [ -z "${drug_prices[${DRUG}]}" ]
    then
        red "Error: Invalid drug selection!"
        return 1
    fi

    local PRICE_PER_UNIT=${drug_prices[${DRUG}]}
    local COST=$((${PRICE_PER_UNIT} * ${QUANTITY}))

    if [ ${MONEY} -lt ${COST} ]
    then
        red "Error: Insufficient funds! You need \$${COST} but only have \$${MONEY}"
        return 1
    fi

    MONEY=$((${MONEY} - ${COST}))
    drugs[${DRUG}]=$((${drugs[${DRUG}]} + ${QUANTITY}))
    POLICE_HEAT=$((${POLICE_HEAT} + ${QUANTITY}))

    green "Bought ${QUANTITY} units of ${drug_names[${DRUG}]} for \$${COST}"
}

sell_drug() {
    local DRUG=$1
    local QUANTITY=$2

    if [ -z "${drugs[${DRUG}]}" ] || [ "${drugs[${DRUG}]}" -lt ${QUANTITY} ]
    then
        red "Error: Insufficient inventory! You only have ${drugs[${DRUG}]:-0} units of ${drug_names[${DRUG}]}, but trying to sell ${QUANTITY}"
        return 1
    fi

    local PRICE=$((${drug_prices[${DRUG}]} * ${QUANTITY}))
    local PROFIT=$((${PRICE} + (RANDOM % 20 - 10)))  # Random profit/loss

    if [ ${PROFIT} -lt 0 ]
    then
        PROFIT=0
    fi

    MONEY=$((${MONEY} + ${PROFIT}))
    drugs[${DRUG}]=$((${drugs[${DRUG}]} - ${QUANTITY}))
    REPUTATION=$((${REPUTATION} + ${QUANTITY}))

    green "Sold ${QUANTITY} units of ${drug_names[${DRUG}]} for \$${PROFIT}"
}

police_encounter() {
    if [ ${POLICE_HEAT} -gt 20 ] && [ $((RANDOM % 100)) -lt 30 ]
    then
        echo
        red "🚔 POLICE RAID! 🚔"
        echo

        local CONFISCATED=0
        for drug in "${!drugs[@]}"; do
            if [ "${drugs[${drug}]}" -gt 0 ]
            then
                local LOSS=$((RANDOM % (drugs[${drug}] / 2 + 1)))
                drugs[${drug}]=$((${drugs[${drug}]} - ${LOSS}))
                CONFISCATED=$((${CONFISCATED} + ${LOSS}))
            fi
        done

        if [ ${CONFISCATED} -gt 0 ]
        then
            red "Police confiscated ${CONFISCATED} units of drugs!"
            HEALTH=$((${HEALTH} - 20))
            POLICE_HEAT=0
        else
            green "You got away clean!"
        fi

        echo
        read -p "Press Enter to continue..."
    fi
}

random_event() {
    local EVENT=$((RANDOM % 10))

    case ${EVENT} in
        0)
            local BONUS=$((RANDOM % 500 + 100))
            MONEY=$((${MONEY} + ${BONUS}))
            green "💰 Found \$${BONUS} on the street!"
            ;;
        1)
            local LOSS=$((RANDOM % 200 + 50))
            if [ ${MONEY} -ge ${LOSS} ]
            then
                MONEY=$((${MONEY} - ${LOSS}))
                red "💸 Got robbed! Lost \$${LOSS}"
            fi
            ;;
        2)
            HEALTH=$((${HEALTH} + 10))
            if [ ${HEALTH} -gt 100 ]
            then
                HEALTH=100
            fi
            green "❤️  Feeling better! Health +10"
            ;;
        3)
            DEBT=$((${DEBT} + 200))
            red "💳 Loan shark demands payment! Debt +\$200"
            ;;
        4)
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
            ;;
    esac
}

check_game_over() {
    if [ ${HEALTH} -le 0 ]
    then
        red "💀 GAME OVER! You died from poor health!"
        GAME_OVER=true
        return
    fi

    if [ ${DEBT} -gt 5000 ]
    then
        red "💀 GAME OVER! Loan sharks got you!"
        GAME_OVER=true
        return
    fi

    if [ ${MONEY} -lt 0 ] && $((${MONEY} + ${DEBT})) -lt -1000 ]
    then
        red "💀 GAME OVER! You're completely broke!"
        GAME_OVER=true
        return
    fi
}

next_day() {
    DAY=$((${DAY} + 1))
    update_prices
    random_event
    police_encounter

    # Pay daily expenses
    local EXPENSES=$((RANDOM % 50 + 20))
    MONEY=$((${MONEY} - ${EXPENSES}))

    if [ ${MONEY} -lt 0 ]
    then
        DEBT=$((${DEBT} - ${MONEY}))
        MONEY=0
    fi

    # Reduce police heat over time
    if [ ${POLICE_HEAT} -gt 0 ]
    then
        POLICE_HEAT=$((${POLICE_HEAT} - 1))
    fi

    # Health slowly decreases
    HEALTH=$((${HEALTH} - 1))
    if [ ${HEALTH} -lt 0 ]
    then
        HEALTH=0
    fi
}
