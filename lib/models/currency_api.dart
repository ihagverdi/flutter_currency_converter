import 'dart:convert';

import 'package:assignment1/classes/currency.dart';
import 'package:http/http.dart' as http;

Future<Currency> fetchCurrency() async {
  final symbols = await http.get(
    Uri.parse('https://api.apilayer.com/fixer/symbols'),
    headers: {'apikey': 'TblhhRo0xyygek77rfq3IfNJR8F8EUIA'},
  );
  final rates = await http.get(
    Uri.parse('https://api.apilayer.com/fixer/latest'),
    headers: {'apikey': 'TblhhRo0xyygek77rfq3IfNJR8F8EUIA'},
  );
  if (symbols.statusCode == 200 && rates.statusCode == 200) {
    final symbolsJson = jsonDecode(symbols.body);
    final ratesJson = jsonDecode(rates.body);

    return Currency.fromJson(symbolsJson, ratesJson);
  } else {
    throw Exception('Failed to fetch currencies');
  }
}
