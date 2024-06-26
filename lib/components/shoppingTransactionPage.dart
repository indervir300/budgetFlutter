import 'package:budget/components/transactionsScaffold.dart';
import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionsScaffold(
      paymentsFuture: fetchPayments('shopping'),
      appBarTitle: 'Shopping Transactions',
      transactionType: 'Shopping',
      baseurl: 'shopping',
    );
  }
}
