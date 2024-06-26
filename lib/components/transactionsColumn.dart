import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final String title;
  final IconData? iconData;

  const Transaction({super.key, required this.title, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
            // margin: const EdgeInsets.only(top: 1),
            height: 90,
            width: double.infinity,
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
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(iconData, color: Colors.blueGrey)),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(title,
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Serif',
                                        color: Colors.black54))
                              ]))),
                  const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(Icons.arrow_forward_ios_outlined,
                          color: Colors.blueGrey))
                ])));
  }
}

class TransactionsColumn extends StatelessWidget {
  final String title;
  final num total;
  final String date;
  final String? transactionType;
  final IconData? iconData;
  final Color? color;

  const TransactionsColumn(
      {super.key,
      required this.title,
      required this.total,
      required this.date,
      this.iconData,
      this.transactionType,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        height: 100,
        width: double.infinity,
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(Icons.paid_outlined, color: Colors.blueGrey)),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Serif',
                                color: Colors.black54)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('₹${total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontFamily: 'Serif',
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold,
                                          color: color))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(date,
                                      style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)))
                            ])
                      ]))),
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(iconData, color: color))
        ]));
  }
}
