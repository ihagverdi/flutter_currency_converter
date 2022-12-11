import 'dart:async';
import 'package:assignment1/classes/currency.dart';
import 'dart:convert' as convert;
import '/screens/conversionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

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
  Currency currencies = Currency();
  var _location = "";
  var _latitude = "";
  var _longitude = "";

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  void initState() {
    super.initState();

    // getCurrencySymbol().then(
    //   (value) {
    //     currencies.currenciesAbbr = value;
    //   },
    // );
    getExchangeRate().then(
      (value) {
        currencies.exchangeRate = value["rates"];
        print(currencies.exchangeRate);
      },
    );

    // Geolocator.isLocationServiceEnabled().then((value) async {
    //   await updatePosition();
    //   if (value == true) {
    //     if (_location != "") {
    //       currencies.currenciesAbbr.forEach((key, value) {
    //         if (key.startsWith(_location)) {
    //           currencies.dropDownValue_from = value;
    //           return;
    //         }
    //       });
    //     }
    //   }
    // });
    // StreamSubscription<ServiceStatus> serviceStatusStream =
    //     Geolocator.getServiceStatusStream()
    //         .listen((ServiceStatus status) async {
    //   if (status == ServiceStatus.enabled) {
    //     await updatePosition();

    //     if (_location != "") {
    //       currencies.dropDownValue_from = "US dollar";
    //     }
    //   }
    // });

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
                        value: currencies.dropDownValue_from,
                        items: currencies.exchangeRate.keys
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
                            currencies.dropDownValue_from = val as String;
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
                                "images/${currencies.dropDownValue_from}.png",
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
                          var temp = currencies.dropDownValue_from;
                          currencies.dropDownValue_from =
                              currencies.dropDownValue_to;
                          currencies.dropDownValue_to = temp;
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
                        value: currencies.dropDownValue_to,
                        items: currencies.exchangeRate.keys
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
                            currencies.dropDownValue_to = val as String;
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
                                "images/${currencies.dropDownValue_to}.png",
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
              currencies.convertCurrency(_amountController).toString() +
                  " " +
                  currencies.currenciesAbbr[currencies.dropDownValue_to]!,
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
              value: currencies.dropDownValue_from,
              items: currencies.exchangeRate.keys
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
                  currencies.dropDownValue_from = val as String;
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
                  child: Image(
                    width: 40.0,
                    image: AssetImage(
                      'icons/flags/png/${currencies.dropDownValue_from.toLowerCase().substring(0, 2)}.png',
                      package: 'country_icons',
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
                var temp = currencies.dropDownValue_from;
                currencies.dropDownValue_from = currencies.dropDownValue_to;
                currencies.dropDownValue_to = temp;
              });
            },
            icon: Icon(Icons.swap_vert_circle),
          ),
          Container(
            //color: Colors.red,
            padding: EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              value: currencies.dropDownValue_to,
              items: currencies.exchangeRate.keys
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
                  currencies.dropDownValue_to = val as String;
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
                  child: Image(
                    width: 40.0,
                    image: AssetImage(
                      'icons/flags/png/${currencies.dropDownValue_to.toLowerCase().substring(0, 2)}.png',
                      package: 'country_icons',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            currencies.convertCurrency(_amountController).toString() +
                " " +
                currencies.currenciesAbbr[currencies.dropDownValue_to]!,
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

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.value(null);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.value(null);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.value(null);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<dynamic> getExchangeRate() async {
    var url = Uri.parse(
        'https://api.apilayer.com/exchangerates_data/latest?base=USD');

    // Await the http get response, then decode the json-formatted response.
    http.Response response = await http
        .get(url, headers: {"apikey": "pGUjhFCZKKr2qx4h66UndNczaedejPLh"});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<dynamic> getCurrencySymbol() async {
    var url = Uri.parse('https://api.apilayer.com/exchangerates_data/symbols"');

    // Await the http get response, then decode the json-formatted response.
    http.Response response = await http
        .get(url, headers: {"apikey": "pGUjhFCZKKr2qx4h66UndNczaedejPLh"});
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse["symbols"];
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> updatePosition() async {
    Position? pos = await _determinePosition();
    if (pos != null) {
      List location =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      setState(() {
        _longitude = pos.longitude.toString();
        _latitude = pos.latitude.toString();
        _location = location[0].isoCountryCode.toString();
      });
    }
  }
}
