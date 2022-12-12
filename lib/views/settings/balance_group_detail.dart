import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:money_app/views/settings/settings.dart';
import 'package:money_app/views/home/home.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/balance_group.dart';

// import 'package:helloworld/authenticate/register.dart';
// import 'package:helloworld/authenticate/login.dart';

class BalanceGroupDetail extends StatefulWidget {
  final List<BalanceGroup> balanceGroup;
  final double total;
  final String type;
  BalanceGroupDetail(this.balanceGroup, this.total, this.type);

  @override
  State<BalanceGroupDetail> createState() => _BalanceGroupDetailState();
}

class _BalanceGroupDetailState extends State<BalanceGroupDetail> {
  String operator = "";
  Color textColor = Colors.black;
  final oCcy = NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == "Tiêu dùng") {
      operator = "-";
      textColor = Colors.red;
    } else {
      operator = "+";
      textColor = Colors.green;
    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#272727"),
          leading: IconButton(
            color: HexColor("#e48d7a"),
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
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
                    Text(
                      "Tổng ${widget.type}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$operator ${oCcy.format(widget.total.round())} ₫",
                      style: TextStyle(
                        color: textColor,
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
                itemCount: widget.balanceGroup.length,
                itemBuilder: (BuildContext c, int index) {
                  return Container(
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
                          offset: const Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                width: 70,
                                imageUrl: widget.balanceGroup[index].categoryLogo,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                widget.balanceGroup[index].categoryName,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          Text(
                            "$operator ${oCcy.format(widget.balanceGroup[index].totalBalance.round())} ₫",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                  );
                }),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
