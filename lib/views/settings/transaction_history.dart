import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TransactionHistory extends StatefulWidget {
  final String userId;
  const TransactionHistory(this.userId);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Lịch sử giao dịch"),
          backgroundColor: HexColor("#272727"),
          leading: IconButton(
              color: HexColor("#e48d7a"),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
        ),
        body: Text(widget.userId)
      ),
    );
  }
}
