import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:money_app/views/home/transaction.dart';
import 'package:money_app/views/home/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../models/balance.dart';
import '../../services/base_client.dart';

// import 'package:helloworld/authenticate/register.dart';
// import 'package:helloworld/authenticate/login.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Balance>? balance;
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() {
    if (mounted && userId != '') {
        balance = fetchBalance();
    }
  }
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  Future<Balance> fetchBalance() async {
    return await BaseClient().getBalance(userId).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoneyApp"),
        backgroundColor: HexColor("#272727"),
      ),
      body: SingleChildScrollView(child: checkLogin()),
    );
  }

  FutureBuilder<SharedPreferences> checkLogin() {
    return FutureBuilder<SharedPreferences>(
        future: _getPrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userId = snapshot.data!.getString('userId') ?? '';
            if (userId == '') {
              return SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: const Center(
                      child: Text("Bạn chưa đăng nhập!!!")));
            }
            getData();
            return balanceInfo();
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  FutureBuilder<Balance> balanceInfo() {
    return FutureBuilder<Balance>(
        future: balance,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return balanceDetail(snapshot.data!);
          }
          if (snapshot.hasData) {
            return balanceDetail(snapshot.data!);
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  Column balanceDetail(Balance balanceDetail) {
    final oCcy = NumberFormat("#,##0", "en_US");
    return Column(
      children: [
        Container(
          height: 150,
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tổng số dư",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${oCcy.format(balanceDetail.totalBalance.round())} ₫",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: balanceDetail.walletAvailableBalanceGetDtos.length,
            itemBuilder: (BuildContext c, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => MyTransaction(
                        userId,
                        balanceDetail
                            .walletAvailableBalanceGetDtos[index].walletId,
                        balanceDetail
                            .walletAvailableBalanceGetDtos[index].walletName,
                        balanceDetail.walletAvailableBalanceGetDtos[index]
                            .availableBalance),
                  ))
                      .then((value) {
                    setState(() {
                      balance = fetchBalance();
                    });
                  });
                },
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          balanceDetail
                              .walletAvailableBalanceGetDtos[index].walletName,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        Text(
                          "${oCcy.format(balanceDetail.walletAvailableBalanceGetDtos[index].availableBalance.round())} ₫",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ]),
                ),
              );
            }),
        const SizedBox(height: 15),
        IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => MyWallet(userId),
              ))
                  .then((value) {
                setState(() {
                  balance = fetchBalance();
                });
              });
            },
            icon: Icon(Icons.add, color: HexColor("#e48d7a"))),
      ],
    );
  }
}
