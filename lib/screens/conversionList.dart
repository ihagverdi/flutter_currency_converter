import 'package:assignment1/classes/currency.dart';
import "package:flutter/material.dart";

class ConversionList extends StatefulWidget {
  ConversionList({super.key});

  @override
  State<ConversionList> createState() => _ConversionListState();
}

class _ConversionListState extends State<ConversionList> {
  Currency currencies_base_usd = Currency();

  List<Widget> ListTileMaker(Currency currencies_base_usd) {
    List<Widget> l = [];
    l.add(Container(
      padding: EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        value: currencies_base_usd.dropDownValue_from,
        items: currencies_base_usd.currencies.keys
            .map(
              (e) => DropdownMenuItem(
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                ),
                value: e,
              ),
            )
            .toList(),
        onChanged: (val) {
          setState(() {
            currencies_base_usd.dropDownValue_from = val as String;
          });
        },
        icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green[400]),
        dropdownColor: Colors.green[50],
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: 20.0,
          ),
          border: OutlineInputBorder(),
          labelText: 'Base Currency',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green[50],
              backgroundImage: AssetImage(
                "images/${currencies_base_usd.dropDownValue_from}.png",
              ),
            ),
          ),
        ),
      ),
    ));

    currencies_base_usd.currencies.forEach((key, value) {
      currencies_base_usd.dropDownValue_to = key;
      l.add(
        Container(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: Colors.green[50],
            leading: CircleAvatar(
              backgroundColor: Colors.green[50],
              backgroundImage: AssetImage(
                "images/$key.png",
              ),
            ),
            title: Text("${key}", style: TextStyle(fontSize: 20.0)),
            trailing: Text(
              '${currencies_base_usd.calculateCurrency('1').toStringAsFixed(5)} ${currencies_base_usd.currencies_abbr[key]}',
            ),
          ),
        ),
      );
    });

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
