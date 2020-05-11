import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'widgetCard.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownMenu = [];
    for (String item in currenciesList) {
      var dropdownMenuItem = DropdownMenuItem(child: Text(item), value: item);
      dropdownMenu.add(dropdownMenuItem);
    }

   return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenu,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker(){
    List<Text> dropdownMenu = [];
    for (String item in currenciesList) {
      var dropdownMenuItem = Text(item);
      dropdownMenu.add(dropdownMenuItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: dropdownMenu,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column initCards() {
    List<WidgetCard> cards = [];
    for (String crypto in cryptoList) {
      cards.add(
        WidgetCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          initCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:  Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
