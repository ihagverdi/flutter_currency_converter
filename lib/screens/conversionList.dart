import "package:flutter/material.dart";

class ConversionList extends StatefulWidget {
  ConversionList({super.key});

  @override
  State<ConversionList> createState() => _ConversionListState();
}

class _ConversionListState extends State<ConversionList> {
  String _dropDownValue_from = '';
  _ConversionListState() {
    _dropDownValue_from = 'US Dollar';
  }
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

  double calculateCurrency(
      String inputAmount, String curr_from, String curr_to) {
    double result =
        (currencies_base_usd[curr_from]! * double.parse(inputAmount)) /
            currencies_base_usd[curr_to]!;
    return result;
  }

  List<Widget> ListTileMaker(Map<String, double> currencies_base_usd) {
    List<Widget> l = [];
    l.add(Container(
      padding: EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        value: _dropDownValue_from,
        items: currencies_base_usd.keys
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
            _dropDownValue_from = val as String;
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
                "images/$_dropDownValue_from.png",
              ),
            ),
          ),
        ),
      ),
    ));

    currencies_base_usd.forEach((key, value) => l.add(Container(
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
              '${calculateCurrency('1', _dropDownValue_from, key).toStringAsFixed(5)} ${currencies_abbr[key]}',
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
