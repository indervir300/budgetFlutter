import 'package:budget/components/transactionsScaffold.dart';
import 'package:flutter/material.dart';

class BusinessTransactionPage extends StatefulWidget {
  const BusinessTransactionPage({super.key});

  @override
  State<BusinessTransactionPage> createState() => _BusinessTransactionState();
}

class _BusinessTransactionState extends State<BusinessTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionsScaffold(
      paymentsFuture: fetchPayments('business'),
      appBarTitle: 'Business Transactions',
      transactionType: 'Business',
      baseurl: 'business',
    );
  }
}