# Drug_Lord.sh

## Overview
This is an attempt to make a version reminiscent of the original DrugLord.exe
that was written by Phil Erwin (FantasyWare Inc 1991-93).
This version is written as a bash script trying to stick to only GNU coreutils.

## File Structure

```
drug_lord/
├── drug_lord.sh              # Main game script
├── README.md                 # This documentation
└── lib/                      # Library directory
    ├── colors.sh             # Color functions and ANSI escape codes
    ├── data.sh               # Game data arrays and initial state
    ├── game.sh               # Core game mechanics and logic
    ├── menus.sh              # All menu functions (buy, sell, travel)
    ├── save.sh               # Save and load game functionality
    └── utils.sh              # Utility functions and display functions
```

## Library Breakdown

### `colors.sh`
- All ANSI color functions (red, green, yellow, blue, etc.)
- Bold and dim text formatting
- Used throughout the game for visual appeal

### `data.sh`
- Game state variables (MONEY, DEBT, DAY, etc.)
- Drug arrays (names, prices, volatility, inventory)
- City system data (names, price multipliers, travel costs)
- Travel cost volatility and base cost arrays
- Initial game state setup

### `game.sh`
- Core game mechanics (buy_drug, sell_drug)
- Price fluctuation algorithms (drugs and travel costs)
- Travel cost fluctuation system with volatility
- Police encounters and random events
- Game over conditions and day progression

### `menus.sh`
- Main menu display
- Buy drugs menu with price indicators
- Sell drugs menu
- Travel menu with city selection and fluctuating costs

### `save.sh`
- Save game state to file
- Load game state from file
- Handles all game variables and arrays (including travel cost data)

### `utils.sh`
- Screen clearing and header display
- Stats and inventory display functions
- City initialization and price calculations
- Enhanced market price display with columnar format and trend indicators

## Usage

Run the game with:
```bash
./drug_lord.sh
```

## Benefits of Modular Structure

1. **Maintainability**: Each function is in its logical library
2. **Readability**: Easier to find and modify specific functionality
3. **Reusability**: Functions can be easily reused across different parts
4. **Testing**: Individual libraries can be tested separately
5. **Collaboration**: Multiple developers can work on different libraries
6. **Documentation**: Each library has a clear, focused purpose
7. **Standard Convention**: Uses the widely recognized `lib/` directory structure

## Dependencies

- `bash` - Shell interpreter
- `bc` - Basic calculator for floating point math
- Standard GNU coreutils (shuf, etc.)

## Features

- 🏙️ **8 Major Cities** with different price multipliers
- ✈️ **Travel System** with fluctuating costs and price adjustments
- 💹 **Dynamic Price Fluctuation** for both drugs and travel costs
- 🎯 **Volatility-Based Travel Costs** (longer distances = higher volatility)
- 🚔 **Police Encounters** and random events
- 💾 **Save/Load System** for persistent gameplay
- 🎨 **Colored Terminal Output** for enhanced visual experience

## Travel Cost Fluctuation System

The game now features dynamic travel costs that fluctuate in real-time, similar to drug prices:

### **Volatility Levels by City:**
- **Seattle**: 25 (Very High) - Longest distance, most price swings
- **Los Angeles**: 20 (High) - Longer distance, significant fluctuations  
- **Las Vegas**: 18 (Medium-High) - Moderate distance, notable changes
- **New York, Denver**: 15 (Medium) - Average volatility
- **Miami**: 12 (Low-Medium) - Shorter distance, smaller changes
- **Chicago**: 10 (Low) - Close distance, stable prices
- **Boston**: 8 (Very Low) - Shortest distance, most stable

### **How It Works:**
- Travel costs fluctuate each time you view the travel menu
- Costs are bounded between 50%-200% of their base values
- Market pressure helps costs return toward base values over time
- Longer distance cities have higher volatility and more dramatic price changes
- The system adds strategic depth to travel planning and timing

### **Real-Time Updates:**
- Costs update dynamically when accessing the travel menu
- Visual indicator shows "✈️ Travel costs fluctuate in real-time!"
- All travel cost data is saved and loaded with your game progress
