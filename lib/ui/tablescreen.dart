import "package:flutter/material.dart";
import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw

// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
void main() {
  runApp(QuoteBuilderApp());
}

class QuoteBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Quote',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ClientInfoPage(),
    );
  }
}

final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

class ClientInfoPage extends StatefulWidget {
  @override
  _ClientInfoPageState createState() => _ClientInfoPageState();
}

class _ClientInfoPageState extends State<ClientInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();

  void goToQuoteForm() {
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuoteFormPage(
            name: nameController.text,
            address: addressController.text,
            reference: referenceController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Client name'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Client Address'),
            ),
            TextField(
              controller: referenceController,
              decoration: InputDecoration(labelText: 'Reference'),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: goToQuoteForm,
                child: Text('Continue to Quote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteFormPage extends StatefulWidget {
  final String name;
  final String address;
  final String reference;

  QuoteFormPage({required this.name, required this.address, required this.reference});

  @override
  _QuoteFormPageState createState() => _QuoteFormPageState();
}

class _QuoteFormPageState extends State<QuoteFormPage> {
  List<Map<String, dynamic>> items = [
    {'name': '', 'quantity': 0.0, 'rate': 0.0, 'discount': 0.0, 'tax': 0.0},
  ];

  void addItem() {
    setState(() {
      items.add({'name': '', 'quantity': 0.0, 'rate': 0.0, 'discount': 0.0, 'tax': 0.0});
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  double get totalWithoutTax => items.fold(0.0, (sum, item) {
    return sum + ((item['rate'] - item['discount']) * item['quantity']);
  });

  double get totalTax => items.fold(0.0, (sum, item) {
    double base = (item['rate'] - item['discount']) * item['quantity'];
    return sum + (base * item['tax'] / 100);
  });

  double get totalWithTax => totalWithoutTax + totalTax;

  void showPreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quote Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client: ${widget.name}'),
              Text('Address: ${widget.address}'),
              if (widget.reference.isNotEmpty) Text('Reference: ${widget.reference}'),
              SizedBox(height: 10),
              ...items.where((item) =>
    item['name'] != null && item['name'].toString().trim().isNotEmpty &&
        item['quantity'] != null &&
        item['rate'] != null &&
        item['discount'] != null &&
        item['tax'] != null
    ).map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product: ${item['name']}'),
                    Text('Qty: ${item['quantity']}, Rate: ${currencyFormat.format(item['rate'])}, Discount: ${currencyFormat.format(item['discount'])}, Tax: ${item['tax']}%'),
                    Divider(),
                  ],
                ),
              )),
              Text('---------------------------'),
              Text('Total (without tax): ${currencyFormat.format(totalWithoutTax)}'),
              Text('Total Tax: ${currencyFormat.format(totalTax)}'),
              Text('Grand Total: ${currencyFormat.format(totalWithTax)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          )
        ],
      ),
    );
  }


  void sendPdfViaWhatsapp() {
        print("Send button clicked.....");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quote Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${widget.name}'),
            Text('Address: ${widget.address}'),
            if (widget.reference.isNotEmpty) Text('Reference: ${widget.reference}'),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('Product Name')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Qty')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Rate')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Discount')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Tax %')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Remove')),
                  ],
                ),
                ...items.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        onChanged: (val) => setState(() => item['name'] = val),
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        onChanged: (val) => setState(() => item['quantity'] = double.tryParse(val) ?? 0.0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        onChanged: (val) => setState(() => item['rate'] = double.tryParse(val) ?? 0.0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        onChanged: (val) => setState(() => item['discount'] = double.tryParse(val) ?? 0.0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        onChanged: (val) => setState(() => item['tax'] = double.tryParse(val) ?? 0.0),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeItem(index),
                      ),
                    ),
                  ]);
                }).toList(),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: showPreview,
              child: Text('Preview Quote'),
            ),
            ElevatedButton(
              onPressed: sendPdfViaWhatsapp,
              child: Text('Save'),
            ),
            Divider(),
            Text('Total (without tax): ${currencyFormat.format(totalWithoutTax)}'),
            Text('Total Tax: ${currencyFormat.format(totalTax)}'),
            Text('Grand Total: ${currencyFormat.format(totalWithTax)}'),
          ],
        ),
      ),
    );
  }
}
