import '/screens/conversionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter Application',
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  _MyHomeState() {
    _dropDownValue_from = 'US Dollar';
    _dropDownValue_to = 'Chinese Yuan';
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
  String _dropDownValue_from = '';
  String _dropDownValue_to = '';
  final _amountController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  double calculateCurrency(
      String inputAmount, String curr_from, String curr_to) {
    double result =
        (currencies_base_usd[curr_from]! * double.parse(inputAmount)) /
            currencies_base_usd[curr_to]!;
    return result;
  }

  double convertCurrency() {
    double result = 0;
    if (_amountController.text.isNotEmpty) {
      String inputAmount = _amountController.text;
      int endIndex = inputAmount.length - 1;
      if (inputAmount[endIndex] == '.') {
        inputAmount = inputAmount.substring(0, endIndex);
      }
      result = calculateCurrency(
          inputAmount, _dropDownValue_from, _dropDownValue_to);
    }
    return double.parse(result.toStringAsFixed(5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Currency Converter'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.currency_exchange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ConversionList();
                }),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              //color: Colors.red,
              child: TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]+[.]?[0-9]*')),
                ],
              ),
            ),
            Container(
              //color: Colors.red,
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
                icon: Icon(Icons.arrow_drop_down_circle,
                    color: Colors.green[400]),
                dropdownColor: Colors.green[50],
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(),
                  labelText: 'From',
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
            ),
            IconButton(
              color: Colors.green[400],
              iconSize: 40.0,
              onPressed: () {
                setState(() {
                  var temp = _dropDownValue_from;
                  _dropDownValue_from = _dropDownValue_to;
                  _dropDownValue_to = temp;
                });
              },
              icon: Icon(Icons.swap_vert_circle),
            ),
            Container(
              //color: Colors.red,
              padding: EdgeInsets.all(10.0),
              child: DropdownButtonFormField(
                value: _dropDownValue_to,
                items: currencies_base_usd.keys
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(
                          e,
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black87),
                        ),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _dropDownValue_to = val as String;
                  });
                },
                icon: Icon(Icons.arrow_drop_down_circle,
                    color: Colors.green[400]),
                dropdownColor: Colors.green[50],
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(),
                  labelText: 'To',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.green[50],
                      backgroundImage: AssetImage(
                        "images/$_dropDownValue_to.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              convertCurrency().toString() +
                  " " +
                  currencies_abbr[_dropDownValue_to]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
