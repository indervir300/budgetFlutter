import 'package:budget/components/transactionsScaffold.dart';
import 'package:flutter/material.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionsScaffold(
        paymentsFuture: fetchPayments('education'),
        appBarTitle: 'Education Fee',
        transactionType: 'Education',
        baseurl: 'education'
    );
  }
}