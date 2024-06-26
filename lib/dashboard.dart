import 'dart:convert';
import 'package:budget/components/about.dart';
import 'package:budget/components/businessTransactionPage.dart';
import 'package:budget/components/donationTransactionPage.dart';
import 'package:budget/components/educationTransactionPage.dart';
import 'package:budget/components/my_account.dart';
import 'package:budget/components/read_token.dart';
import 'package:budget/components/shoppingTransactionPage.dart';
import 'package:budget/components/homeTransactionPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:budget/login.dart';
import 'package:budget/components/transactionsColumn.dart';
import 'package:flutter/material.dart';
import 'package:budget/components/incomeGraph.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:budget/jwttoken.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

final List<Transaction> transactions = [
  const Transaction(
      title: 'Education', iconData: FontAwesomeIcons.graduationCap),
  const Transaction(title: 'Business', iconData: FontAwesomeIcons.businessTime),
];

Future<List<IncomeExpenseData>> fetchGraphData(String url) async {
  final userId = await getUserIdFromToken();
  final response = await http.get(Uri.parse('$url/$userId'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final count = data['count'] as int;
    final amounts = List<int>.from(data['amounts']);

    List<IncomeExpenseData> incomeExpenseData = [];

    for (int i = 0; i < count; i++) {
      incomeExpenseData
          .add(IncomeExpenseData((i + 1).toString(), amounts[i].toDouble()));
    }

    return incomeExpenseData;
  } else {
    throw Exception('Failed to load!');
  }
}

Future<Map<String, dynamic>> getTransactions(String url) async {
  final userId = await getUserIdFromToken();
  final response = await http.get(Uri.parse('$url/$userId'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  } else {
    throw Exception('Failed to load!');
  }
}

class IncomeGraph extends StatefulWidget {
  final Function()? onRefresh;
  const IncomeGraph({super.key, this.onRefresh});
  @override
  State<IncomeGraph> createState() => _IncomeGraphState();
}

class _IncomeGraphState extends State<IncomeGraph> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchGraphData('${Config.baseUrl}/graphdata'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 60.0,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load Graph Data!'),
          );
        } else {
          final data = snapshot.data!;
          return SizedBox(
            child: Chart(
              data,
              animate: true,
            ),
          );
        }
      },
    );
  }
}

class _DashboardState extends State<Dashboard> {
  void refresh() {
    incomeGraphKey.currentState!.widget.onRefresh;
    setState(() {});
  }

  final GlobalKey<_IncomeGraphState> incomeGraphKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
        body: Column(children: <Widget>[
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: userService.fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SpinKitFadingCircle(
                                color: Colors.deepPurple, size: 40.0));
                      } else {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Hey! ',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 22)),
                              TextSpan(
                                  text: userService.users[0].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 17))
                            ])));
                      }
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          onPressed: () {
                            refresh();
                          },
                          icon: const Icon(Icons.refresh_outlined))),
                ],
              ),
            ),
          ),
          SizedBox(
              height: 220,
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 5.0,
                              spreadRadius: 0.0,
                              offset: const Offset(1.0, 2.0),
                            )
                          ]),
                      child: Column(children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Text('Analytics',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    letterSpacing: 1,
                                    fontFamily: "Serif",
                                    color: Colors.black54))),
                        SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IncomeGraph(
                                  key: incomeGraphKey,
                                  onRefresh: refresh,
                                )))
                      ])))),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: const Offset(2.0, 2.0))
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Transactions ',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Serif',
                                  letterSpacing: 1,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800))),
                      FutureBuilder(
                        future: getTransactions(
                            '${Config.baseUrl}/gettransactions'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SpinKitFadingCircle(
                                    color: Colors.deepPurple, size: 30.0));
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Failed to load!'));
                          } else {
                            final data = snapshot.data!;
                            final String totalTransactions =
                                data['totalTransactions'].toString();
                            return Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Text(totalTransactions,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Serif',
                                        letterSpacing: 1,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w800)));
                          }
                        },
                      )
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue),
                      child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.house,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeTransactionsPage()));
                          })),
                  Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DonationPage()));
                          },
                          icon: const Icon(FontAwesomeIcons.handHoldingHeart,
                              color: Colors.white))),
                  Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShoppingPage()));
                          },
                          icon: const Icon(FontAwesomeIcons.bagShopping,
                              color: Colors.white)))
                ]),
          ),
          Expanded(
              flex: 1,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return SizedBox(
                        width: double.infinity,
                        child: Column(children: [
                          InkWell(
                              child: Transaction(
                                  title: transaction.title,
                                  iconData: transaction.iconData),
                              onTap: () {
                                // print(transaction.title);
                                if (transaction.title == 'Education') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EducationPage()));
                                } else if (transaction.title == 'Business') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BusinessTransactionPage()));
                                }
                              })
                        ]));
                  },
                  itemCount: transactions.length))
        ]),
        bottomNavigationBar: SizedBox(
            height: 60,
            child: BottomAppBar(
                color: Colors.white12,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: IconButton(
                            onPressed: () {
                              logout();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.black45,
                            )),
                      ),
                      Expanded(
                          flex: 3,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => About()));
                              },
                              icon: const Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Colors.black45,
                              ))),

                      Expanded(
                          flex: 4,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyAccount()));
                              },
                              icon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              ))),

                    ]))));
  }
}
