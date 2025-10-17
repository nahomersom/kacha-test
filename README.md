# Cacha Test - Remittance App

A modern remittance application built with Flutter and Riverpod. Features persistent authentication, wallet management, money transfers, currency exchange, and a beautiful responsive UI.

## ✨ Features

### 🔐 Authentication
- **User Registration**: Name, email, password with strength indicator
- **User Login**: Email/password authentication with persistent storage
- **Password Security**: Real-time strength indicator with visual feedback
- **Form Validation**: Email format validation and required field checks
- **Success Feedback**: Toast notifications for login/registration success

### 💰 Wallet Management
- **Dashboard**: Modern UI with balance display and quick actions
- **Transaction History**: Real-time transaction list with persistent storage
- **Balance Tracking**: Automatic balance updates after transfers
- **Currency Support**: Multiple currency options (USD, EUR, GBP, etc.)

### 💸 Money Transfer
- **Recipient Details**: Name, contact, bank information, account number
- **Amount & Currency**: Flexible amount input with currency selection
- **Transfer Simulation**: Loading states, success/error feedback
- **Balance Validation**: Insufficient balance error handling
- **Transaction Recording**: Automatic transaction history updates

### 💱 Currency Exchange
- **Real-time Calculator**: Convert between different currencies
- **Popular Currencies**: Quick selection grid for common currencies
- **Exchange Rates**: Fixed rates for demo purposes
- **Amount Input**: Dynamic conversion as you type

### 🎨 User Experience
- **Modern UI**: Clean, responsive design with gradients and shadows
- **Theme Support**: Light and dark mode with system preference detection
- **Navigation**: Bottom navigation bar with 4 main sections
- **Feedback**: Toast messages, loading indicators, and success dialogs
- **Responsive**: Optimized for different screen sizes

## 🏗️ Tech Stack & Architecture

### **State Management**
- **Riverpod**: `StateNotifierProvider`, `FutureProvider`, `Provider`
- **Reactive UI**: Real-time updates with proper state management
- **Persistent Storage**: `shared_preferences` for data persistence

### **Architecture Layers**
- **UI Layer**: Flutter screens with modern design patterns
- **Business Logic**: Riverpod controllers and providers
- **Data Layer**: Persistent repositories with local storage
- **Models**: Type-safe data models with validation

### **Key Technologies**
- **Flutter**: Cross-platform mobile development
- **Riverpod**: State management and dependency injection
- **Shared Preferences**: Local data persistence
- **Screen Util**: Responsive design utilities
- **Material Design**: Modern UI components

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with theme management
├── features/
│   ├── auth/                          # Authentication system
│   │   ├── controllers/               # Auth state management
│   │   ├── screens/                   # Login/Register screens
│   │   └── persistent_auth_repository.dart
│   ├── wallet/                        # Wallet management
│   │   ├── wallet_controller.dart
│   │   └── persistent_wallet_repository.dart
│   ├── transfer/                      # Money transfer logic
│   │   └── transfer_provider.dart
│   ├── exchange/                      # Currency exchange
│   │   └── exchange_controller.dart
│   └── shell/                         # Main app shell
│       └── app_shell.dart             # Bottom navigation & screens
├── models/                            # Data models
│   ├── user.dart
│   ├── wallet.dart
│   ├── transaction.dart
│   └── currency.dart
├── theme/                             # App theming
│   ├── colors.dart
│   ├── typography.dart
│   ├── app_theme_light.dart
│   └── app_theme_dark.dart
└── utils/                             # Utilities
    └── validators.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.9)
- Dart SDK (>= 3.0)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cacha_test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For specific device
   flutter run -d <device-id>
   ```

## 📱 Usage Guide

### **1. Authentication**
- **Registration**: Create account with name, email, and password
- **Password Strength**: Real-time indicator shows password requirements
- **Login**: Use registered credentials to access the app
- **Persistent Sessions**: Stay logged in between app restarts

### **2. Dashboard**
- **Balance Overview**: View current wallet balance and currency
- **Quick Actions**: Send money and exchange rate buttons
- **Transaction History**: Recent transactions with details
- **Modern UI**: Clean, responsive design with gradients

### **3. Send Money**
- **Recipient Info**: Name, contact, bank details, account number
- **Amount & Currency**: Enter amount and select currency
- **Transfer Process**: Loading states with success/error feedback
- **Balance Updates**: Automatic balance and transaction updates

### **4. Currency Exchange**
- **Rate Calculator**: Convert between different currencies
- **Popular Currencies**: Quick selection for common currencies
- **Real-time Conversion**: See converted amounts instantly
- **Multiple Currencies**: Support for USD, EUR, GBP, and more

### **5. Settings**
- **Theme Toggle**: Switch between light and dark modes
- **Logout**: Secure logout with data clearing
- **System Integration**: Follows system theme preferences

## 🔧 Development

### **State Management**
- **Riverpod**: Reactive state management with providers
- **Persistent Storage**: Local data persistence with shared_preferences
- **Type Safety**: Strong typing with Dart models

### **Key Features Implemented**
- ✅ **Persistent Authentication**: Login/logout with data persistence
- ✅ **Wallet Management**: Balance tracking and transaction history
- ✅ **Money Transfers**: Complete transfer flow with validation
- ✅ **Currency Exchange**: Real-time conversion calculator
- ✅ **Modern UI**: Responsive design with theme support
- ✅ **Error Handling**: Comprehensive error states and feedback
- ✅ **Form Validation**: Email validation and required field checks
- ✅ **Password Security**: Strength indicators and validation

### **Architecture Decisions**
- **Riverpod**: Chosen for simplicity, testability, and clear separation
- **Persistent Storage**: Local storage for demo purposes (replace with API for production)
- **Fixed Exchange Rates**: Deterministic rates for demo (replace with live API)
- **Mock Data**: Simulated transfers and transactions for testing

## 🎯 Demo Flow

**Recommended user journey:**
1. **Register** → Create new account with strong password
2. **Dashboard** → View balance and recent transactions  
3. **Send Money** → Transfer funds with recipient details
4. **Exchange** → Convert between different currencies
5. **Settings** → Toggle dark mode and explore options
6. **Logout** → Secure logout and return to login

## 📝 Notes

- **Demo Purpose**: This is a prototype for demonstration and testing
- **Production Ready**: Replace mock data with real APIs and services
- **Security**: Implement proper authentication and encryption for production
- **Scalability**: Architecture supports easy feature additions and modifications

