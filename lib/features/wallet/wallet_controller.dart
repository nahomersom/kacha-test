import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/currency.dart';
import '../../models/transaction.dart';
import '../../models/wallet.dart';
import 'persistent_wallet_repository.dart';

class WalletController extends StateNotifier<WalletModel> {
  WalletController(this._persistentRepo) : super(
    const WalletModel(
      balance: 1000.0, // Starting balance
      currency: Currency.usd,
      transactions: [],
    ),
  ) {
    _loadSavedWallet();
  }

  final PersistentWalletRepository _persistentRepo;

  // Load saved wallet on initialization
  Future<void> _loadSavedWallet() async {
    final savedWallet = await _persistentRepo.getSavedWallet();
    if (savedWallet != null) {
      state = savedWallet;
    } else {
      // Save initial wallet state
      await _persistentRepo.saveWallet(state);
      await _persistentRepo.saveTransactions(state.transactions);
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final updated = List<TransactionModel>.from(state.transactions)..insert(0, transaction);
    state = state.copyWith(transactions: updated);
    await _persistentRepo.saveTransactions(updated);
  }

  Future<void> adjustBalance(double delta) async {
    final newBalance = state.balance + delta;
    state = state.copyWith(balance: newBalance);
    await _persistentRepo.saveWallet(state);
  }

  Future<void> setCurrency(Currency currency) async {
    state = state.copyWith(currency: currency);
    await _persistentRepo.saveWallet(state);
  }
}

final persistentWalletRepositoryProvider = Provider<PersistentWalletRepository>((ref) => PersistentWalletRepository());

final walletProvider = StateNotifierProvider<WalletController, WalletModel>((ref) {
  final persistentRepo = ref.read(persistentWalletRepositoryProvider);
  return WalletController(persistentRepo);
});


