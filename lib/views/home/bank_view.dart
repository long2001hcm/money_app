import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/bank.dart';
import '../../models/category.dart';
import '../../services/base_client.dart';

class BankView extends StatefulWidget {
  @override
  State<BankView> createState() => _BankViewState();
}

class _BankViewState extends State<BankView> {
  Future<List<Bank>>? banks;
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    if (mounted) {
      setState(() {
        banks = fetchBanks();
      });
    }
  }

  Future<List<Bank>> fetchBanks() async {
    return await BaseClient().getBanks().catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Chọn ngân hàng"),
          backgroundColor: HexColor("#272727"),
          leading: IconButton(
            color: HexColor("#e48d7a"),
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: categoryInfo(),
      ),
    );
  }

  FutureBuilder<List<Bank>> categoryInfo() {
    return FutureBuilder<List<Bank>>(
        future: banks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return bankDetail(snapshot.data!);
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  ListView bankDetail(List<Bank> bank) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: bank.length,
        itemBuilder: (BuildContext c, int index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, bank[index]);
                },
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                  child: Row(children: [
                    CachedNetworkImage(
                      width: 70,
                      imageUrl: bank[index].logo,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      bank[index].bankName,
                      style: const TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                  ]),
                ),
              ),
            ],
          );
        });
  }
}
