import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/currency.dart';
import '../../models/transaction.dart';
import '../wallet/wallet_controller.dart';

class TransferRequest {
  final String recipientName;
  final String contact;
  final String bankName;
  final String accountNumber;
  final double amount;
  final Currency currency;

  const TransferRequest({
    required this.recipientName,
    required this.contact,
    required this.bankName,
    required this.accountNumber,
    required this.amount,
    required this.currency,
  });
}

final transferProvider = FutureProvider.family<bool, TransferRequest>((ref, req) async {
  await Future.delayed(const Duration(seconds: 1));

  // Simulate potential failure
  if (req.amount <= 0) {
    throw Exception('Amount must be greater than zero');
  }

  final wallet = ref.read(walletProvider.notifier);

  // Check if user has sufficient balance
  final currentWallet = ref.read(walletProvider);
  if (currentWallet.balance < req.amount) {
    throw Exception('Insufficient balance');
  }

  await wallet.adjustBalance(-req.amount);
  await wallet.addTransaction(
    TransactionModel(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      amount: -req.amount, // Negative amount for outgoing transactions
      currency: req.currency,
      recipientName: req.recipientName,
      createdAt: DateTime.now(),
    ),
  );
  return true;
});


