#!/bin/bash

# Game data arrays
declare -A drugs=(
    ["weed"]=0
    ["cocaine"]=0
    ["heroin"]=0
    ["meth"]=0
    ["ecstasy"]=0
)

declare -A drug_prices=(
    ["weed"]=10
    ["cocaine"]=50
    ["heroin"]=80
    ["meth"]=30
    ["ecstasy"]=25
)

declare -A drug_volatility=(
    ["weed"]=5      # Low volatility
    ["cocaine"]=15  # High volatility
    ["heroin"]=20   # Very high volatility
    ["meth"]=10     # Medium volatility
    ["ecstasy"]=8   # Medium-low volatility
)

declare -A base_prices=(
    ["weed"]=10
    ["cocaine"]=50
    ["heroin"]=80
    ["meth"]=30
    ["ecstasy"]=25
)

declare -A drug_names=(
    ["weed"]="🌿 Weed"
    ["cocaine"]="❄️ Cocaine "
    ["heroin"]="💉 Heroin"
    ["meth"]="🧪 Meth"
    ["ecstasy"]="💊 Ecstasy"
)

# City system
declare -A cities=(
    ["newyork"]="🗽 New York"
    ["losangeles"]="🌴 Los Angeles"
    ["chicago"]="🏙️ Chicago"
    ["miami"]="🏖️ Miami"
    ["lasvegas"]="🎰 Las Vegas"
    ["seattle"]="☕ Seattle"
    ["boston"]="🎓 Boston"
    ["denver"]="🏔️ Denver"
)

declare -A city_price_multipliers=(
    ["newyork"]="1.2"      # Expensive city
    ["losangeles"]="1.1"   # Slightly expensive
    ["chicago"]="1.0"      # Average prices
    ["miami"]="0.9"        # Slightly cheaper
    ["lasvegas"]="1.3"     # Very expensive
    ["seattle"]="1.1"      # Slightly expensive
    ["boston"]="1.2"       # Expensive
    ["denver"]="0.8"       # Cheaper
)

declare -A city_travel_costs=(
    ["newyork"]="150"
    ["losangeles"]="200"
    ["chicago"]="100"
    ["miami"]="120"
    ["lasvegas"]="180"
    ["seattle"]="250"
    ["boston"]="80"
    ["denver"]="160"
)

# Initialize game state variables
MONEY=1000
DEBT=0
DAY=1
HEALTH=100
REPUTATION=0
POLICE_HEAT=0
GAME_OVER=false

# Initialize random starting city
CURRENT_CITY=""