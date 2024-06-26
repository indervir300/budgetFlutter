import 'dart:convert';
import 'package:budget/components/popup_widget.dart';
import 'package:budget/components/read_token.dart';
import 'package:budget/components/transactionsColumn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:budget/config.dart';

Future<List<TransactionsColumn>> fetchPayments(url) async {
  final userId = await getUserIdFromToken();
  final response = await http
      .get(Uri.parse('${Config.baseUrl}/getpayments/$url/$userId'));

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    final List<dynamic> jsonPayments = jsonBody['payments'];
    return jsonPayments
        .map((jsonPayment) => TransactionsColumn(
              title: jsonPayment['title'],
              total: jsonPayment['amount'],
              date: jsonPayment['formattedDate'],
              transactionType: jsonPayment['transactionType'],
              iconData: jsonPayment['transactionType'] == 'paid'
                  ? Icons.arrow_upward_outlined
                  : jsonPayment['transactionType'] == 'received'
                      ? Icons.arrow_downward_outlined
                      : null,
              color: jsonPayment['transactionType'] == 'paid'
                  ? Colors.redAccent
                  : jsonPayment['transactionType'] == 'received'
                      ? Colors.green
                      : null,
            ))
        .toList();
  } else {
    throw Exception('Failed to load payments');
  }
}

class TransactionsScaffold extends StatefulWidget {
  final Future<List<TransactionsColumn>> paymentsFuture;
  final String? appBarTitle;
  final String? transactionType;
  final String? baseurl;

  const TransactionsScaffold(
      {super.key,
      required this.paymentsFuture,
      this.appBarTitle,
      this.transactionType,
      this.baseurl});

  @override
  State<TransactionsScaffold> createState() => _TransactionsScaffoldState();
}

class _TransactionsScaffoldState extends State<TransactionsScaffold> {
  Future<List<TransactionsColumn>>? _paymentsFuture;

  String buttonType = '';

  @override
  void initState() {
    super.initState();
    _paymentsFuture = widget.paymentsFuture.then((payments) => payments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.appBarTitle!,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<List<TransactionsColumn>>(
          future: _paymentsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final payments = snapshot.data!;
              if (payments.isEmpty) {
                return const Center(
                    child: Text('No Transactions found',
                        style: TextStyle(fontSize: 17)));
              }
              return ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return TransactionsColumn(
                        title: payment.title,
                        total: payment.total,
                        date: payment.date,
                        transactionType: payment.transactionType,
                        iconData: payment.iconData,
                        color: payment.color);
                  });
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Something went wrong! or No Internet!'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: Container(
            color: Colors.white,
            height: 70.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Distribute evenly
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            buttonType = 'received';
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddEntryPopup(
                                onSubmit: (title, amount) async {
                                  if (title.isNotEmpty && amount > 0.0) {
                                    try {
                                      final userId = await getUserIdFromToken();
                                      final url = Uri.parse(
                                          '${Config.baseUrl}/add_payment/${widget.baseurl}');
                                      final headers = {
                                        'Content-Type': 'application/json',
                                      };
                                      final body = jsonEncode({
                                        'title': title,
                                        'amount': amount.toDouble(),
                                        'userId': userId,
                                        'transactionType': buttonType
                                      });

                                      final response = await http.post(url,
                                          headers: headers, body: body);

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _paymentsFuture = fetchPayments(
                                              '${widget.baseurl}');
                                        });
                                      } else {
                                        print(
                                            'Error sending data: ${response.statusCode}');
                                      }
                                    } catch (error) {
                                      print('Error: $error');
                                    }
                                  } else {
                                    print(
                                        'Please enter a valid title and amount.');
                                  }
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Text('Received',
                                  style: TextStyle(
                                      color: Colors.white))), // Green color
                        )),
                  ),
                  Expanded(
                      flex: 4,
                      child: ElevatedButton(
                          onPressed: () {
                            buttonType = 'paid';
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddEntryPopup(
                                onSubmit: (title, amount) async {
                                  if (title.isNotEmpty && amount > 0.0) {
                                    try {
                                      final userId = await getUserIdFromToken();
                                      final url = Uri.parse(
                                          '${Config.baseUrl}/add_payment/${widget.baseurl}');
                                      final headers = {
                                        'Content-Type': 'application/json',
                                      };
                                      final body = jsonEncode({
                                        'title': title,
                                        'amount': amount.toDouble(),
                                        'userId': userId,
                                        'transactionType': buttonType
                                      });

                                      final response = await http.post(url,
                                          headers: headers, body: body);

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _paymentsFuture = fetchPayments(
                                              '${widget.baseurl}');
                                        });
                                      } else {
                                        print(
                                            'Error sending data: ${response.statusCode}');
                                      }
                                    } catch (error) {
                                      print('Error: $error');
                                    }
                                  } else {
                                    print(
                                        'Please enter a valid title and amount.');
                                  }
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Text('Paid',
                                  style: TextStyle(color: Colors.white)))))
                ])));
  }
}
