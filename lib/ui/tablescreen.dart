import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Calculation/cal.dart';

final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

class QuoteFormPage extends StatefulWidget {
  final String name;
  final String address;
  final String reference;

  QuoteFormPage({
    required this.name,
    required this.address,
    required this.reference,
  });

  @override
  _QuoteFormPageState createState() => _QuoteFormPageState();
}

enum QuoteStatus { Draft, Sent, Accepted }

class _QuoteFormPageState extends State<QuoteFormPage> {
  List<Map<String, dynamic>> items = [
    {'name': '', 'quantity': 0.0, 'rate': 0.0, 'discount': 0.0, 'tax': 0.0},
  ];
  bool isSending = false;
  QuoteStatus quoteStatus = QuoteStatus.Draft;

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

  void showPreview() {
    double totalWithoutTax = calculateTotalWithoutTax(items);
    double totalTax = calculateTotalTax(items);
    double totalWithTax = calculateTotalWithTax(items);

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
              item['name'].toString().trim().isNotEmpty).map((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product: ${item['name']}'),
                  Text('Qty: ${item['quantity']}, Rate: ${currencyFormat.format(item['rate'])}, '
                      'Discount: ${currencyFormat.format(item['discount'])}, Tax: ${item['tax']}%'),
                  Divider(),
                ],
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
          ),
        ],
      ),
    );
  }

  Future<void> simulateSendQuote() async {
    setState(() {
      isSending = true;
      quoteStatus = QuoteStatus.Sent;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() => isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('📤 Quote marked as Sent!')),
    );
  }

  void markAsAccepted() {
    setState(() {
      quoteStatus = QuoteStatus.Accepted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Quote marked as Accepted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalWithoutTax = calculateTotalWithoutTax(items);
    double totalTax = calculateTotalTax(items);
    double totalWithTax = calculateTotalWithTax(items);

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
                  decoration: BoxDecoration(color: Colors.blueGrey[300]),
                  children: [
                    for (final label in ['Product Name', 'Qty', 'Rate', 'Discount', 'Tax %', 'Remove'])
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(label),
                      ),
                  ],
                ),
                ...items.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  return TableRow(children: [
                    for (final key in ['name', 'quantity', 'rate', 'discount', 'tax'])
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              item[key] = key == 'name'
                                  ? val
                                  : double.tryParse(val) ?? 0.0;
                            });
                          },
                          keyboardType: key == 'name'
                              ? TextInputType.text
                              : TextInputType.number,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button background
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Add Item'),
            ),

            ElevatedButton(
              onPressed: showPreview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
              child: Text('Preview Quote'),
            ),

            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: isSending ? Text('Sending...') : Text('Send Quote'),
              onPressed: isSending ? null : simulateSendQuote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),

            ElevatedButton.icon(
              icon: Icon(Icons.check_circle_outline),
              label: Text('Mark as Accepted'),
              onPressed: quoteStatus == QuoteStatus.Sent ? markAsAccepted : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
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
