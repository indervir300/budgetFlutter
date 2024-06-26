import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          _buildListTile(
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _buildListTile(
            title: 'Description',
            subtitle:
                """Budget Tracker is your all-in-one money management app, designed to simplify tracking your income and expenses. Effortlessly record your incoming and outgoing funds with just a few taps.

Here's how Budget Tracker empowers you:

* Streamlined Transaction Tracking:  Seamlessly add income and expense entries. Categorize your transactions for clear insights into your spending habits.
* Visualize Your Budget Flow: Gain valuable insights with clear charts and graphs. See where your money goes and identify areas for potential savings.
""",
          ),
          _buildListTile(
            title: 'Developed by',
            subtitle: 'Indervir Singh',
          ),
          _buildListTile(
            title: 'Contact',
            subtitle: 'indervirsinghji300@gmail.com',
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({required String title, String? subtitle}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }
}
