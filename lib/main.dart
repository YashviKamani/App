
import 'package:flutter/material.dart';
import 'package:quote_demo/ui/home.dart';

void main() {
  runApp(QuoteBuilderApp());
}

class QuoteBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Quote Builder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ClientInfoPage(),
    );
  }
}





