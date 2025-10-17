import 'currency.dart';
import 'transaction.dart';

class WalletModel {
  final double balance;
  final Currency currency;
  final List<TransactionModel> transactions;

  const WalletModel({
    required this.balance,
    required this.currency,
    required this.transactions,
  });

  WalletModel copyWith({
    double? balance,
    Currency? currency,
    List<TransactionModel>? transactions,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      transactions: transactions ?? this.transactions,
    );
  }
}


