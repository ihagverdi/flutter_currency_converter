import 'package:flutter/material.dart';

class Currency {
  late Map<String, double> currencies;
  final currencies_abbr = {
    'US Dollar': 'USD',
    'Euro': 'EUR',
    'South Korean Wan': 'KRW',
    'Chinese Yuan': 'CNY',
    'Japanese Yen': 'JPY',
    'Swedish Krona': 'SEK',
    'British Pound': 'GBP',
  };
  late String dropDownValue_from;
  late String dropDownValue_to;

  Currency(
      {Map<String, double> currencies = const {
        'US Dollar': 1.0,
        'Euro': 1.03,
        'South Korean Wan': 0.00075,
        'Chinese Yuan': 0.14,
        'Japanese Yen': 0.0071,
        'Swedish Krona': 0.094,
        'British Pound': 1.19,
      },
      String dropDownValue_from = 'US Dollar',
      String dropDownValue_to = 'Swedish Krona'}) {
    this.currencies = currencies;
    this.dropDownValue_from = dropDownValue_from;
    this.dropDownValue_to = dropDownValue_to;
  }
  double calculateCurrency(String inputAmount) {
    double result =
        (currencies[dropDownValue_from]! * double.parse(inputAmount)) /
            currencies[dropDownValue_to]!;
    return result;
  }

  double convertCurrency(TextEditingController amountController) {
    double result = 0;
    if (amountController.text.isNotEmpty) {
      String inputAmount = amountController.text;
      int endIndex = inputAmount.length - 1;
      if (inputAmount[endIndex] == '.') {
        inputAmount = inputAmount.substring(0, endIndex);
      }
      result = calculateCurrency(inputAmount);
    }
    return double.parse(result.toStringAsFixed(5));
  }
}
