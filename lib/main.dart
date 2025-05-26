import 'package:flutter/material.dart';
import 'package:quote_demo/ui/home.dart';
import 'package:quote_demo/ui/tablescreen.dart';

void main() {
  runApp(QuoteBuilderApp());
}

class QuoteBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Quote',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ClientInfoPage(),
        '/quoteForm': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return QuoteFormPage(
            name: args['name'],
            address: args['address'],
            reference: args['reference'],
          );
        },
      },
    );
  }
}
