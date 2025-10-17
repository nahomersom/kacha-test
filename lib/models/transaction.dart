import 'currency.dart';

class TransactionModel {
  final String id;
  final double amount;
  final Currency currency;
  final String recipientName;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.recipientName,
    required this.createdAt,
  });
}


