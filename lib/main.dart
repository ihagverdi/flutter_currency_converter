import 'package:assignment1/classes/currency.dart';
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
  final _amountController = TextEditingController();
  Currency currencies_base_usd = Currency();
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape();
        },
      ),
    );
  }

  Widget buildLandscape() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
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
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: DropdownButtonFormField(
                        isExpanded: true,
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
                            currencies_base_usd.dropDownValue_from =
                                val as String;
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
                                "images/${currencies_base_usd.dropDownValue_from}.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      color: Colors.green[400],
                      iconSize: 40.0,
                      onPressed: () {
                        setState(() {
                          var temp = currencies_base_usd.dropDownValue_from;
                          currencies_base_usd.dropDownValue_from =
                              currencies_base_usd.dropDownValue_to;
                          currencies_base_usd.dropDownValue_to = temp;
                        });
                      },
                      icon: Icon(Icons.swap_horizontal_circle),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: currencies_base_usd.dropDownValue_to,
                        items: currencies_base_usd.currencies.keys
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black87),
                                ),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            currencies_base_usd.dropDownValue_to =
                                val as String;
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
                                "images/${currencies_base_usd.dropDownValue_to}.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              currencies_base_usd
                      .convertCurrency(_amountController)
                      .toString() +
                  " " +
                  currencies_base_usd
                      .currencies_abbr[currencies_base_usd.dropDownValue_to]!,
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

  Widget buildPortrait() {
    return Container(
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
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]?[0-9]*')),
              ],
            ),
          ),
          Container(
            //color: Colors.red,
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
              icon:
                  Icon(Icons.arrow_drop_down_circle, color: Colors.green[400]),
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
                      "images/${currencies_base_usd.dropDownValue_from}.png",
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
                var temp = currencies_base_usd.dropDownValue_from;
                currencies_base_usd.dropDownValue_from =
                    currencies_base_usd.dropDownValue_to;
                currencies_base_usd.dropDownValue_to = temp;
              });
            },
            icon: Icon(Icons.swap_vert_circle),
          ),
          Container(
            //color: Colors.red,
            padding: EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              value: currencies_base_usd.dropDownValue_to,
              items: currencies_base_usd.currencies.keys
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  currencies_base_usd.dropDownValue_to = val as String;
                });
              },
              icon:
                  Icon(Icons.arrow_drop_down_circle, color: Colors.green[400]),
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
                      "images/${currencies_base_usd.dropDownValue_to}.png",
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            currencies_base_usd.convertCurrency(_amountController).toString() +
                " " +
                currencies_base_usd
                    .currencies_abbr[currencies_base_usd.dropDownValue_to]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
