import 'package:budget/components//transactionsScaffold.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionsScaffold(
      paymentsFuture: fetchPayments('donation'),
      appBarTitle: 'Donation Transactions',
      transactionType: 'Donation',
      baseurl: 'donation',
    );
  }
}
