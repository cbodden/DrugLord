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
- Initial game state setup

### `game.sh`
- Core game mechanics (buy_drug, sell_drug)
- Price fluctuation algorithms
- Police encounters and random events
- Game over conditions and day progression

### `menus.sh`
- Main menu display
- Buy drugs menu with price indicators
- Sell drugs menu
- Travel menu with city selection

### `save.sh`
- Save game state to file
- Load game state from file
- Handles all game variables and arrays

### `utils.sh`
- Screen clearing and header display
- Stats and inventory display functions
- City initialization and price calculations
- Market price display

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
- ✈️ **Travel System** with costs and price adjustments
- 💹 **Dynamic Price Fluctuation** based on city and volatility
- 🚔 **Police Encounters** and random events
- 💾 **Save/Load System** for persistent gameplay
- 🎨 **Colored Terminal Output** for enhanced visual experience
