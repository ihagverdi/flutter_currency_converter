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

  double convertCurrency() {
    double result = 0;
    if (_amountController.text.isNotEmpty &&
        (_amountController.text[_amountController.text.length - 1] != '.')) {
      result = (currencies_base_usd[_dropDownValue_from]! *
              double.parse(_amountController.text)) /
          currencies_base_usd[_dropDownValue_to]!;
    }
    return double.parse(result.toStringAsFixed(8));
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
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black87),
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
                    child: Image(
                      height: 20.0,
                      image: AssetImage(
                        "images/$_dropDownValue_from.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  var temp = _dropDownValue_from;
                  _dropDownValue_from = _dropDownValue_to;
                  _dropDownValue_to = temp;
                });
              },
              icon: Icon(Icons.swap_vert),
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
                    child: Image(
                      height: 20.0,
                      image: AssetImage(
                        "images/$_dropDownValue_to.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              convertCurrency().toString(),
              style: TextStyle(
                fontSize: 40.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
