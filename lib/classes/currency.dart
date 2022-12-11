import 'package:flutter/material.dart';

class Currency {
  late Map<String, dynamic> exchangeRate;
  final currenciesAbbr = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'KRW': 'South Korean Wan',
    'CNY': 'Chinese Yuan',
    'JPY': 'Japanese Yen',
    'SEK': 'Swedish Krona',
    'GBP': 'British Pound',
  };
  late String dropDownValue_from;
  late String dropDownValue_to;

  Currency(
      {this.exchangeRate = const {
        'USD': 1.0,
        'EUR': 1.03,
        'SKW': 0.00075,
        'CNY': 0.14,
        'JPY': 0.0071,
        'SEK': 0.094,
        'GBP': 1.19,
      },
      this.dropDownValue_from = 'USD',
      this.dropDownValue_to = 'SEK'});

  double calculateCurrency(String inputAmount) {
    double result =
        (exchangeRate[dropDownValue_from]! * double.parse(inputAmount)) /
            exchangeRate[dropDownValue_to]!;
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
