enum Currency { usd, eur, gbp, kes, ngn }

extension CurrencyX on Currency {
  String get code => switch (this) {
        Currency.usd => 'USD',
        Currency.eur => 'EUR',
        Currency.gbp => 'GBP',
        Currency.kes => 'KES',
        Currency.ngn => 'NGN',
      };
}


