import 'package:budget/components/close_account.dart';
import 'package:budget/components/read_token.dart';
import 'package:budget/jwttoken.dart';
import 'package:budget/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../config.dart';

class MyAccount extends StatefulWidget {
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return Scaffold(
        appBar: AppBar(
            title: const Text('My Account',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: Colors.white)),
            backgroundColor: Colors.blue),
        body: Center(
            child: SizedBox(
                height: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: CircleAvatar(
                                  radius: 90,
                                  child: Image.asset('assets/images/graph.png',
                                      width: 170, height: 170)))),
                      FutureBuilder(
                          future: userService.fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SpinKitFadingCircle(
                                      color: Colors.blue, size: 60.0));
                            } else {
                              return Column(children: [
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            hintText: userService.users[0].name,
                                            fillColor: Colors.white70,
                                            prefixIcon:
                                                const Icon(Icons.person)))),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            hintText:
                                                userService.users[0].email,
                                            fillColor: Colors.white70,
                                            prefixIcon: const Icon(
                                                Icons.email_outlined)))),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            hintText: userService
                                                .users[0].dateCreated,
                                            fillColor: Colors.white70,
                                            prefixIcon:
                                                const Icon(Icons.date_range)))),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            hintText:
                                                userService.users[0].userId,
                                            fillColor: Colors.white70,
                                            prefixIcon: const Icon(
                                                Icons.info_outline)))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm Deletion!'),
                                                content: const Text(
                                                    'Are you sure you want to permanently delete your account? This process cannot be undone.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      final userId =
                                                          await getUserIdFromToken();
                                                      final url = Uri.parse(
                                                          '${Config.baseUrl}/deleteaccount/users/$userId');

                                                      try {
                                                        final response = await http.delete(url);

                                                        if (response.statusCode == 204) {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => const Login()));
                                                          await logout();
                                                        } else {
                                                          print('Error deleting account: ${response.statusCode}');
                                                        }
                                                      } catch (error) {
                                                        print('Error deleting account: $error');
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors
                                                          .red, // Optional: Set text color for emphasis
                                                    ),
                                                    child: const Text(
                                                        'Yes, Delete'),
                                                  ),

                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red.shade400,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text('Close Account'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ]);
                            }
                          })
                    ]))));
  }
}
