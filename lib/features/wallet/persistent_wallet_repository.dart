import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/currency.dart';
import '../../models/transaction.dart';
import '../../models/wallet.dart';

class PersistentWalletRepository {
  static const String _walletKey = 'wallet_data';
  static const String _transactionsKey = 'transactions_data';

  // Save wallet data to persistent storage
  Future<void> saveWallet(WalletModel wallet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletKey, jsonEncode({
      'balance': wallet.balance,
      'currency': wallet.currency.code,
    }));
  }

  // Get saved wallet data
  Future<WalletModel?> getSavedWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final walletJson = prefs.getString(_walletKey);
    if (walletJson != null) {
      try {
        final walletMap = jsonDecode(walletJson) as Map<String, dynamic>;
        final transactions = await getTransactions();
        return WalletModel(
          balance: walletMap['balance'] as double,
          currency: Currency.values.firstWhere(
            (c) => c.code == walletMap['currency'],
            orElse: () => Currency.usd,
          ),
          transactions: transactions,
        );
      } catch (e) {
        // If parsing fails, remove the corrupted data
        await prefs.remove(_walletKey);
      }
    }
    return null;
  }

  // Save transactions
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions.map((t) => {
      'id': t.id,
      'amount': t.amount,
      'currency': t.currency.code,
      'recipientName': t.recipientName,
      'createdAt': t.createdAt.toIso8601String(),
    }).toList();
    await prefs.setString(_transactionsKey, jsonEncode(transactionsJson));
  }

  // Get transactions
  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString(_transactionsKey);
    if (transactionsJson != null) {
      try {
        final List<dynamic> transactionsList = jsonDecode(transactionsJson);
        return transactionsList.map((t) => TransactionModel(
          id: t['id'] as String,
          amount: t['amount'] as double,
          currency: Currency.values.firstWhere(
            (c) => c.code == t['currency'],
            orElse: () => Currency.usd,
          ),
          recipientName: t['recipientName'] as String,
          createdAt: DateTime.parse(t['createdAt'] as String),
        )).toList();
      } catch (e) {
        // If parsing fails, remove the corrupted data
        await prefs.remove(_transactionsKey);
      }
    }
    return [];
  }

  // Clear all wallet data
  Future<void> clearAllWalletData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_walletKey);
    await prefs.remove(_transactionsKey);
  }
}
