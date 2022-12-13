import 'package:assignment1/classes/currency.dart';
import "package:flutter/material.dart";

class ConversionList extends StatefulWidget {
  final Currency myCurrency;
  String localCurrency;
  ConversionList(
      {super.key, required this.myCurrency, required this.localCurrency});

  @override
  State<ConversionList> createState() => _ConversionListState();
}

class _ConversionListState extends State<ConversionList> {
  List<DropdownMenuItem<String>> myItems() {
    List<DropdownMenuItem<String>> result = [];
    widget.myCurrency.symbols.forEach((key, value) {
      result.add(DropdownMenuItem(
        value: key,
        child: Text(value),
      ));
    });
    return result;
  }

  List<Widget> makeTiles() {
    List<Widget> listPage = [];
    listPage.add(Container(
      padding: EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        value: widget.localCurrency,
        items: myItems(),
        onChanged: (val) {
          setState(() {
            widget.localCurrency = val as String;
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
          prefixIcon: Container(
            padding: EdgeInsets.all(8),
            width: 50,
            //color: Colors.red,
            child: Image.asset(
                'icons/currency/${widget.localCurrency.toLowerCase()}.png',
                package: 'currency_icons'),
          ),
        ),
      ),
    ));

    widget.myCurrency.symbols.forEach((key, value) {
      listPage.add(
        Container(
          padding: EdgeInsets.all(5),
          child: ListTile(
            tileColor: Colors.green[50],
            leading: Container(
              padding: EdgeInsets.all(8),
              width: 50,
              //color: Colors.red,
              child: Image.asset('icons/currency/${key.toLowerCase()}.png',
                  package: 'currency_icons'),
            ),
            title: Text("${value}", style: TextStyle(fontSize: 20.0)),
            trailing: Text(
              '${widget.myCurrency.convertCurrency('1', widget.localCurrency, key)} ${key}',
            ),
          ),
        ),
      );
    });

    return listPage;
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
      ),
      body: ListView(
        children: makeTiles(),
      ),
    );
  }
}
