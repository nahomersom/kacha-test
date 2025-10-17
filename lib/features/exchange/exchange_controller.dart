import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/currency.dart';

class ExchangeState {
  final Currency from;
  final Currency to;
  final double rate; // from -> to

  const ExchangeState({required this.from, required this.to, required this.rate});

  ExchangeState copyWith({Currency? from, Currency? to, double? rate}) {
    return ExchangeState(from: from ?? this.from, to: to ?? this.to, rate: rate ?? this.rate);
  }
}

class ExchangeController extends StateNotifier<ExchangeState> {
  ExchangeController() : super(const ExchangeState(from: Currency.usd, to: Currency.eur, rate: 0.92));

  // Simple fixed mock rates map
  static const Map<Currency, Map<Currency, double>> _rates = {
    Currency.usd: {Currency.usd: 1, Currency.eur: 0.92, Currency.gbp: 0.78, Currency.kes: 130, Currency.ngn: 1600},
    Currency.eur: {Currency.usd: 1.09, Currency.eur: 1, Currency.gbp: 0.85, Currency.kes: 142, Currency.ngn: 1740},
    Currency.gbp: {Currency.usd: 1.28, Currency.eur: 1.17, Currency.gbp: 1, Currency.kes: 167, Currency.ngn: 2050},
    Currency.kes: {Currency.usd: 0.0077, Currency.eur: 0.0070, Currency.gbp: 0.0060, Currency.kes: 1, Currency.ngn: 12.3},
    Currency.ngn: {Currency.usd: 0.00062, Currency.eur: 0.00057, Currency.gbp: 0.00049, Currency.kes: 0.081, Currency.ngn: 1},
  };

  void setCurrencies({Currency? from, Currency? to}) {
    final nextFrom = from ?? state.from;
    final nextTo = to ?? state.to;
    final nextRate = _rates[nextFrom]![nextTo]!;
    state = state.copyWith(from: nextFrom, to: nextTo, rate: nextRate);
  }

  double convert(double amount) => amount * state.rate;
}

final exchangeControllerProvider = StateNotifierProvider<ExchangeController, ExchangeState>((ref) {
  return ExchangeController();
});


