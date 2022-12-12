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

class MyBankWallet extends StatefulWidget {
  const MyBankWallet();

  @override
  // ignore: library_private_types_in_public_api
  _MyBankWalletState createState() => _MyBankWalletState();
}

class _MyBankWalletState extends State<MyBankWallet> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo ví liên kết ngân hàng"),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            right: 35,
            left: 35,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: userEmailController,
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
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: accountNumberController,
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
                hintText: 'Số tài khoản',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: userPasswordController,
              obscureText: true,
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
                hintText: 'Mật khẩu',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            IconButton(
              color: HexColor("#e48d7a"),
              onPressed: () async {
                var wallet = {
                  "userEmail": userEmailController.text.toString(),
                  "accountNumber": accountNumberController.text.toString(),
                  "userPassword": userPasswordController.text.toString(),
                  "thirdPartySignature": "be9b2e18-0fac-40ac-8f82-002992d38bcb"
                };
                var response = await BaseClient()
                    .post2('/Webhook/sign-up/user', wallet)
                    .catchError((err) { print(err); });
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
    );
  }
}
