import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:money_app/views/settings/authenticate/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:money_app/views/settings/transaction_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(Settings());
}

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    // if (mounted && userId != '') {
    //   setState(() {
    //     balance = fetchBalance();
    //   });
    // }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BookHub"),
          backgroundColor: HexColor("#272727"),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLogin(),));
                },
              ),
              ElevatedButton(
                child: const Text('Logout'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('token', "");
                  await prefs.setString('userId', "");
                },
              ),
              ElevatedButton(
                child: const Text('Lịch sử giao dịch'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistory(userId),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}