import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    if (mounted && userId != '') {
      setState(() {
        balance = fetchBalance();
      });
    }
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
      body: SingleChildScrollView(child: balanceInfo()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("A");
        },
        backgroundColor: HexColor("#e48d7a"),
        child: const Icon(Icons.add),
      ),
    );
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: balanceDetail.walletAvailableBalanceGetDtos.length,
            itemBuilder: (BuildContext c, int index) {
              return GestureDetector(
                onTap: () {
                  print("A");
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
