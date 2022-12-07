import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:money_app/views/settings/authenticate/login.dart';
import 'package:hexcolor/hexcolor.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BookHub"),
          backgroundColor: HexColor("#272727"),
          actions: [
            IconButton(
              color: HexColor("#e48d7a"),
              onPressed: () {
                 
              },
              icon: const Icon(Icons.add_shopping_cart_rounded),
            )
          ],
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
            ],
          ),
        ),
      ),
    );
  }
}