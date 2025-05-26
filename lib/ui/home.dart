import 'package:flutter/material.dart';

class ClientInfoPage extends StatefulWidget {
  @override
  _ClientInfoPageState createState() => _ClientInfoPageState();
}

class _ClientInfoPageState extends State<ClientInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();

  void goToQuoteForm(BuildContext context) {
    if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/quoteForm',
        arguments: {
          'name': nameController.text,
          'address': addressController.text,
          'reference': referenceController.text,
        },
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
                onPressed: () => goToQuoteForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // 🔵 Button background color
                  foregroundColor: Colors.white, // ⚪️ Text (and icon) color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Optional: Adjust size
                ),
                child: Text('Continue to Quote'),
              ),

              ),
          ],
        ),
      ),
    );
  }
}
