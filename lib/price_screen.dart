import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';
  String selectedCurrency = 'USD';
  String currentBTC;
  String currentETH;
  String currentLTC;

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      var newItem = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> items = [];
    for (int i = 0; i < currenciesList.length; i++) {
      items.add(Text(currenciesList[i]));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: items,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    }
    return androidDropdown();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      currentBTC = '?';
      currentETH = '?';
      currentLTC = '?';
    });
    for (int i = 0; i < cryptoList.length; i++) {
      String tempCurrency = cryptoList[i];
      String link = '$url/$tempCurrency$selectedCurrency';

      http.Response res = await http
          .get(link, headers: {'x-ba-key': 'NTVkNTRiMzQ1N2YzNDgxNjk4NTYxY2U4ODFmYjZmMWI'});

      var decode = jsonDecode(res.body)['last'];

      setState(() {
        if (tempCurrency == 'BTC') {
          currentBTC = decode.toString();
        } else if (tempCurrency == 'ETH') {
          currentETH = decode.toString();
        } else if (tempCurrency == 'LTC') {
          currentLTC = decode.toString();
        }
      });
    }
  }

  List<Widget> getAll() {
    List<Widget> items = [];

    String result;

    for (int i = 0; i < cryptoList.length; i++) {
      String crypto = cryptoList[i];

      if (crypto == 'BTC') {
        result = '1 $crypto = ${currentBTC ?? '?'} $selectedCurrency';
      } else if (crypto == 'ETH') {
        result = '1 $crypto = ${currentETH ?? '?'} $selectedCurrency';
      } else if (crypto == 'LTC') {
        result = '1 $crypto = ${currentLTC ?? '?'} $selectedCurrency';
      }

      var newItem = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      items.add(newItem);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
//    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: getAll(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
