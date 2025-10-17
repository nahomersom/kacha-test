# Remittance App Prototype

A basic remittance app built with Flutter and Riverpod. Users can register/login, view wallet balance and transactions, send money, calculate exchange rates, and toggle light/dark themes.

## Features

- Authentication: mock register/login with validation (email, strong password)
- Wallet dashboard: balance and recent transactions
- Money transfer: recipient info, bank/account, amount/currency; async loading and errors
- Exchange calculator: select currencies and see converted amount
- Theming: light/dark toggle in settings and app bar

## Tech & Architecture

- State management: Riverpod (`StateNotifierProvider`, `StateProvider`, `FutureProvider`)
- Layers:
  - UI: Flutter screens under `lib/features/**`
  - Logic: Riverpod controllers/providers
  - Data: in-memory mock repositories
- Models: `UserModel`, `WalletModel`, `TransactionModel`, `Currency`

## Project Structure

- `lib/main.dart`: app entry, theming, auth-guarded home
- `lib/features/auth/`: validators, mock repo, controller, login/register screens
- `lib/features/wallet/`: wallet controller/state
- `lib/features/transfer/`: transfer provider and request model
- `lib/features/exchange/`: exchange controller/state and conversion
- `lib/features/shell/`: bottom-nav app shell with Dashboard/Send/Exchange/Settings

## Setup

1. Install Flutter (>= 3.9)
2. Install deps:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Usage Walkthrough

1. Register a new account or login with any registered email/password
2. After login, you land on Dashboard with balance and transactions
3. Send tab: fill recipient, contact, bank, account, amount, currency → Send
   - Shows loading; on success, balance decrements and a transaction is added
4. Exchange tab: pick From/To currencies and amount to see converted value
5. Settings tab or app bar: toggle dark mode; app bar also provides Logout

## Notes & Decisions

- Mock auth only: in-memory storage for demo purposes
- Fixed mock FX rates for determinism; replace with API for production
- Riverpod chosen for simplicity, testability, and clear separation of concerns

## Demo

- Suggested flow to record:
  1) Register → 2) Dashboard → 3) Send → 4) Dashboard updates → 5) Exchange → 6) Dark mode toggle → 7) Logout

