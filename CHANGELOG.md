# Changelog

All notable changes to DrugLord will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1] - 2024-12-19

### Added
- 🏦 **Banking System**: Complete financial management with savings and loans
- 💰 **Savings Account**: 5% daily interest on deposits
- 💳 **Loan System**: 15% daily interest borrowing with flexible terms
- 📊 **Financial Tracking**: Comprehensive banking information display
- ⏰ **Daily Processing**: Automatic interest calculation and loan management

### Banking Features
- **Savings Interest**: 5% daily compound interest
- **Loan Management**: High-risk 15% daily interest loans
- **Overdue Protection**: Automatic conversion to general debt
- **Financial Planning**: Balance cash flow and investment strategies

### Changed
- Updated main menu to include banking option (option 7)
- Enhanced stats display to show banking information
- Updated save system to include banking variables
- Improved menu formatting to prevent staggering on double-digit options

## [2.0] - 2024-12-19

### Added
- 🏥 **Hospital System**: Complete healing system with dynamic pricing
- 💰 **Emergency Fees**: Higher costs for critical health conditions
- 🔄 **Multiple Treatment Options**: Full, partial, and basic treatments

### Fixed
- ✅ **Save File Bug**: Fixed critical save file naming inconsistency
- ✅ **Input Validation**: Enhanced validation for all menu inputs
- ✅ **Error Handling**: Improved error messages and user feedback
- ✅ **Save System**: Added automatic backup creation and integrity validation
- ✅ **File Safety**: Backup restoration on save failures

### Improved
- 🎯 **Better Error Messages**: More descriptive and consistent error feedback
- 🔒 **Input Safety**: Comprehensive validation prevents crashes
- 💾 **Save Reliability**: Backup system prevents data loss
- 🎨 **User Experience**: Enhanced visual feedback and menu organization

## [1.0] - 2024-12-19

### Added
- Initial release of DrugLord Terminal Edition
- 🏙️ **8 Major Cities** with different price multipliers
- ✈️ **Travel System** with fluctuating costs and price adjustments
- 💹 **Dynamic Price Fluctuation** for both drugs and travel costs
- 🎯 **Volatility-Based Travel Costs** (longer distances = higher volatility)
- 🚔 **Police Encounters** and random events
- 💾 **Save/Load System** for persistent gameplay
- 🎨 **Colored Terminal Output** for enhanced visual experience
- ✅ **Comprehensive Input Validation** and error handling

### Features
- Core drug trading mechanics (buy/sell)
- City-based price variations
- Real-time price fluctuations
- Police raid system
- Random events
- Modular code structure with separate libraries
- Complete save/load functionality