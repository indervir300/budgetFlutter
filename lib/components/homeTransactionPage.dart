import 'package:budget/components//transactionsScaffold.dart';
import 'package:flutter/material.dart';

class HomeTransactionsPage extends StatefulWidget {
  const HomeTransactionsPage({super.key});

  @override
  State<HomeTransactionsPage> createState() => _HomeTransactionsState();
}

class _HomeTransactionsState extends State<HomeTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionsScaffold(
      paymentsFuture: fetchPayments('housepayments'),
      appBarTitle: 'Home Transactions',
      transactionType: 'housepayments',
      baseurl: 'housepayments',
    );
  }
}