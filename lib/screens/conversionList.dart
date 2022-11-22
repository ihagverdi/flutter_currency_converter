import "package:flutter/material.dart";
import 'package:country_icons/country_icons.dart';

class ConversionList extends StatelessWidget {
  ConversionList({super.key});
  final currencies_base_usd = {
    'US Dollar': 1.0,
    'Euro': 1.03,
    'South Korean Wan': 0.00075,
    'Chinese Yuan': 0.14,
    'Japanese Yen': 0.0071,
    'Swedish Krona': 0.094,
    'British Pound': 1.19,
  };
  final currencies_abbr = {
    'US Dollar': 'USD',
    'Euro': 'EUR',
    'South Korean Wan': 'KRW',
    'Chinese Yuan': 'CNY',
    'Japanese Yen': 'JPY',
    'Swedish Krona': 'SEK',
    'British Pound': 'GBP',
  };
  List<Widget> ListTileMaker(Map<String, double> currencies_base_usd) {
    List<Widget> l = [];
    currencies_base_usd.forEach((key, value) => l.add(Container(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            tileColor:
                key == "US Dollar" ? Colors.green[200] : Colors.green[50],
            leading: CircleAvatar(
              backgroundColor:
                  key == "US Dollar" ? Colors.green[200] : Colors.green[50],
              backgroundImage: AssetImage(
                "images/$key.png",
              ),
            ),
            title: Text("${key}", style: TextStyle(fontSize: 20.0)),
            trailing: Text(
              '$value ${currencies_abbr[key]}',
            ),
          ),
        )));
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Conversion Rates'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: ListTileMaker(currencies_base_usd),
      ),
    );
  }
}
