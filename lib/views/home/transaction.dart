import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_app/views/settings/authenticate/register.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../../models/login_user.dart';
import '../../../../services/base_client.dart';
import '../../models/balance.dart';
import '../../services/text_formater.dart';
import 'category_view.dart';

class MyTransaction extends StatefulWidget {
  final String userId;
  final String walletId;
  final double balance;
  final String walletName;
  const MyTransaction(this.userId, this.walletId, this.walletName, this.balance);

  @override
  // ignore: library_private_types_in_public_api
  _MyTransactionState createState() => _MyTransactionState();
}

class _MyTransactionState extends State<MyTransaction> {
  int categoryId = 15;
  String categoryName = "";
  String categoryLogo = "";
  final oCcy = NumberFormat("#,##0", "en_US");
  late TextEditingController walletNameController;
  late TextEditingController balanceController;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletNameController = TextEditingController(text: widget.walletName);
    balanceController = TextEditingController(text: oCcy.format(widget.balance.round()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo giao dịch"),
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
                      enabled: false,
                      controller: balanceController,
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
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixText: "₫",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: amountController,
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
                        hintText: 'Nhập số tiền',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixText: "₫",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => CategoryView(),
                        ))
                            .then((value) {
                          if(mounted && value != null) {
                            setState(() {
                              categoryId = value.id;
                              categoryName = value.name;
                              categoryLogo = value.logo;
                            });
                          }
                        });
                      },
                      child: Column(
                        children: [
                          if (categoryName == "") ... [
                          Container(
                            height: 60,
                            width: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                              child: Text("Chọn loại giao dịch",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              
                              ),
                            ),
                          ),
                          ] else ... [
                            Container(
                              height: 60,
                              width: 500,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(children: [
                                const SizedBox(width: 15),
                                Image.network(
                                  categoryLogo,
                                  width: 50,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  categoryName,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 17),
                                ),
                              ]),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: descriptionController,
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
                        hintText: 'Ghi chú',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    IconButton(
                      color: HexColor("#e48d7a"),
                      onPressed: () async {
                        var transaction = {
                          "walletId": widget.walletId,
                          "userId": widget.userId,
                          "amount": int.parse(amountController.text),
                          "description": descriptionController.text,
                          "transactionType": categoryId,
                        };
                        if (walletNameController.text != widget.walletName) {
                          var response = await BaseClient()
                              .post('/Wallet/${widget.walletId}/rename?name="${walletNameController.text}"',
                                  transaction)
                              .catchError((err) {});
                        }
                        var response = await BaseClient()
                            .post('/Wallet/cash/create-transaction', transaction)
                            .catchError((err) {});
                        if (response.statusCode == 200) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                  title: Text("Fail"),
                                  content: Text("Tạo giao dịch thất bại!!!")),
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
