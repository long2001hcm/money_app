import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_app/views/settings/authenticate/register.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../../models/login_user.dart';
import '../../../../services/base_client.dart';
import '../../services/text_formater.dart';

class MyWallet extends StatefulWidget {
  final String userId;
  const MyWallet(this.userId);

  @override
  // ignore: library_private_types_in_public_api
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  TextEditingController walletNameController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo ví"),
        leading: IconButton(
          color: HexColor("#e48d7a"),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: HexColor("#272727"),
        elevation: 0,
        toolbarHeight: 60,
      ),
      backgroundColor: HexColor("#272727"),
      body: Stack(children: [
        if (widget.userId == "") ...[
          const Center(child: Text("Đăng nhập"))
        ] else ...[
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                right: 35,
                left: 35,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TextField(
                      controller: walletNameController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: HexColor("#e48d7a")),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        hintText: 'Tên ví',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: HexColor("#e48d7a")),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        hintText: 'Số dư',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixText: "₫",
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    IconButton(
                      color: HexColor("#e48d7a"),
                      onPressed: () async {
                        var wallet = {
                          "walletName": walletNameController.text,
                          "userId": widget.userId,
                          "availableBalance": int.parse(balanceController.text)
                        };
                        var response = await BaseClient()
                            .post('/Wallet/cash/create-wallet', wallet)
                            .catchError((err) {});
                        if (response.statusCode == 200) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                  title: Text("Fail"),
                                  content: Text("Tạo ví thất bại!!!")),
                              barrierDismissible: true);
                        }
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ]),
            ),
          ),
        ]
      ]),
    );
  }
}
