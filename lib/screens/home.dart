import 'package:assignment1/classes/currency.dart';
import 'package:assignment1/models/currency_api.dart';
import 'package:assignment1/models/location.dart';
import 'package:assignment1/screens/conversionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _pageLoading = true;
  late Currency myCurrency;
  late Position? myPosition;
  late List<Placemark> placemarks;
  final amountController = TextEditingController();

  late String localCurrency;
  late String currFrom;
  String currTo = 'AZN';

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  void initState() {
    super.initState();
    fetchData();
    amountController.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchData() async {
    myCurrency = await fetchCurrency();

    myPosition = await determinePosition();
    if (myPosition != null) {
      placemarks = await placemarkFromCoordinates(
          myPosition!.latitude, myPosition!.longitude);
      currFrom = getPositionCurrency();
      localCurrency = currFrom;
    } else {
      currFrom = 'EUR';
      localCurrency = 'EUR'; // make local EUR if not defined
    }
    setState(() {
      _pageLoading = false;
    });
  }

  String getPositionCurrency() {
    String? countryCode = placemarks[0].isoCountryCode;
    String countryCurrency = myCurrency.symbols.keys
        .firstWhere((element) => element.startsWith(countryCode.toString()));
    return countryCurrency.toString(); // for example, 'USD'
  }

  List<DropdownMenuItem<String>> myItems() {
    List<DropdownMenuItem<String>> result = [];
    myCurrency.symbols.forEach((key, value) {
      result.add(DropdownMenuItem(
        value: key,
        child: Text(value),
      ));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Context = MediaQuery.of(context).orientation;

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
                  return ConversionList(
                    myCurrency: myCurrency,
                    localCurrency: localCurrency,
                    key: widget.key,
                  );
                }),
              );
            },
          ),
        ],
      ),
      body: _pageLoading == true
          ? Center(child: CircularProgressIndicator())
          : (Context == Orientation.portrait
              ? buildPortrait()
              : buildLandscape()),
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
              controller: amountController,
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
              value: currFrom,
              items: myItems(),
              onChanged: (val) {
                setState(() {
                  currFrom = val as String;
                });
              },
              icon:
                  Icon(Icons.arrow_drop_down_circle, color: Colors.green[400]),
              dropdownColor: Colors.green[50],
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20.0),
                border: OutlineInputBorder(),
                labelText: 'From',
                prefixIcon: Container(
                  padding: EdgeInsets.all(8),
                  width: 50,
                  //color: Colors.red,
                  child: Image.asset(
                      'icons/currency/${currFrom.toLowerCase()}.png',
                      package: 'currency_icons'),
                ),
              ),
            ),
          ),
          IconButton(
            color: Colors.green[400],
            iconSize: 40.0,
            onPressed: () {
              setState(() {
                var temp = currFrom;
                currFrom = currTo;
                currTo = temp;
              });
            },
            icon: Icon(Icons.swap_vert_circle),
          ),
          Container(
            //color: Colors.red,
            padding: EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              value: currTo,
              items: myItems(),
              onChanged: (val) {
                setState(() {
                  currTo = val as String;
                });
              },
              icon:
                  Icon(Icons.arrow_drop_down_circle, color: Colors.green[400]),
              dropdownColor: Colors.green[50],
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20.0),
                border: OutlineInputBorder(),
                labelText: 'To',
                prefixIcon: Container(
                  padding: EdgeInsets.all(8),
                  width: 50,
                  //color: Colors.red,
                  child: Image.asset(
                      'icons/currency/${currTo.toLowerCase()}.png',
                      package: 'currency_icons'),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            myCurrency
                    .convertCurrency(amountController.text, currFrom, currTo)
                    .toString() +
                " " +
                currTo,
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

  Widget buildLandscape() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            //color: Colors.red,
            child: TextFormField(
              controller: amountController,
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
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  //color: Colors.red,
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: currFrom,
                    items: myItems(),
                    onChanged: (val) {
                      setState(() {
                        currFrom = val as String;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down_circle,
                        color: Colors.green[400]),
                    dropdownColor: Colors.green[50],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      labelText: 'From',
                      prefixIcon: Container(
                        padding: EdgeInsets.all(8),
                        width: 50,
                        //color: Colors.red,
                        child: Image.asset(
                            'icons/currency/${currFrom.toLowerCase()}.png',
                            package: 'currency_icons'),
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
                      var temp = currFrom;
                      currFrom = currTo;
                      currTo = temp;
                    });
                  },
                  icon: Icon(Icons.swap_horizontal_circle),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  //color: Colors.red,
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: currTo,
                    items: myItems(),
                    onChanged: (val) {
                      setState(() {
                        currTo = val as String;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down_circle,
                        color: Colors.green[400]),
                    dropdownColor: Colors.green[50],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      labelText: 'To',
                      prefixIcon: Container(
                        padding: EdgeInsets.all(8),
                        width: 50,
                        //color: Colors.red,
                        child: Image.asset(
                            'icons/currency/${currTo.toLowerCase()}.png',
                            package: 'currency_icons'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            myCurrency
                    .convertCurrency(amountController.text, currFrom, currTo)
                    .toString() +
                " " +
                currTo,
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
