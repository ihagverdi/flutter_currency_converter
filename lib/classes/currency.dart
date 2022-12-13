import 'package:flutter/material.dart';

class Currency {
  final Map<String, dynamic> symbols;
  final Map<String, dynamic> rates;
  final String base;

  const Currency(
      {required this.symbols, required this.rates, required this.base});

  factory Currency.fromJson(
      Map<String, dynamic> symbolsJson, Map<String, dynamic> ratesJson) {
    return Currency(
      symbols: symbolsJson['symbols'],
      rates: ratesJson['rates'],
      base: ratesJson['base'],
    );
  }

  double convertCurrency(
      String amountController, String currFrom, String currTo) {
    double result = 0;
    if (amountController.isNotEmpty) {
      String inputAmount = amountController;
      int endIndex = inputAmount.length - 1;
      if (inputAmount[endIndex] == '.') {
        inputAmount = inputAmount.substring(0, endIndex);
      }
      result = (rates[currTo]! * double.parse(inputAmount)) / rates[currFrom]!;
    }
    return double.parse(result.toStringAsFixed(5));
  }
}
