
import 'package:flutter/material.dart';
import 'package:money_app/views/settings/settings.dart';
import 'package:money_app/views/home/home.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:helloworld/authenticate/register.dart';
// import 'package:helloworld/authenticate/login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  int currentIndex = 0;
  final screens = [
    Home(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: HexColor("#272727"),
          selectedItemColor: Colors.white,
          unselectedItemColor: HexColor("#e48d7a"),
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'User',
              icon: Icon(Icons.person),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
