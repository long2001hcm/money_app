import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_history.dart';
import '../../services/base_client.dart';

class TransactionHistoryView extends StatefulWidget {
  final String userId;
  const TransactionHistoryView(this.userId);

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  Future<List<TransactionHistory>>? transactionHistory;
  final oCcy = NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    if (mounted && widget.userId != '') {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat("MM/dd/yyyy");
      final String formatted = formatter.format(now);
      transactionHistory = fetchTransactionHistory(formatted);
      print(transactionHistory);
    }
  }

  Future<List<TransactionHistory>> fetchTransactionHistory(
      String formatted) async {
    return await BaseClient()
        .getTransactionHistory(widget.userId, formatted)
        .catchError((err) {
      print(err);
    });
  }

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
          body: SingleChildScrollView(child: Column(children: [transactionHistoryInfo()]))),
    );
  }

  FutureBuilder<List<TransactionHistory>> transactionHistoryInfo() {
    return FutureBuilder<List<TransactionHistory>>(
        future: transactionHistory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return transactionHistoryDetail(snapshot.data!);
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  ListView transactionHistoryDetail(List<TransactionHistory> history) {
    var inputFormat = DateFormat('MM/dd/yyyy');
    var outputFormat = DateFormat('dd/MM/yyyy');
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: history.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
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
          child: ExpandablePanel(
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  outputFormat
                      .format(inputFormat.parse(history[index].createdAt)),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            expanded:
                transactionHistoryDetailed(history[index].transactionGetDtos),
            collapsed: Column(children: [
              Row(
                children: [
                  const Text("Thu nhập: "),
                  Text(
                      "+ ${oCcy.format(history[index].totalIncoming.round())} ₫",
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text("Tiêu dùng: "),
                  Text(
                      "- ${oCcy.format(history[index].totalOutcoming.round())} ₫",
                      style: const TextStyle(color: Colors.red)),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  ListView transactionHistoryDetailed(List<TransactionGetDto> historyDetail) {
    var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var outputFormat = DateFormat("HH:mm:ss");
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: historyDetail.length,
        itemBuilder: (BuildContext c, int index) {
          return Container(
            height: 140,
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Tên ví: ", style: TextStyle(color: Colors.grey)),
                      Text(
                        historyDetail[index].walletName,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Thời gian: ",
                          style: TextStyle(color: Colors.grey)),
                      Text(outputFormat.format(inputFormat
                          .parse(historyDetail[index].createdAt.toString()))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Loại giao dịch: ",
                          style: TextStyle(color: Colors.grey)),
                      Text(historyDetail[index]
                          .categoryTransactionGetDtos[0]
                          .name),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Số tiền: ",
                          style: TextStyle(color: Colors.grey)),
                      
                      if (historyDetail[index].transactionType == "Outcoming") ...[
                        Text(
                            "- ${oCcy.format(historyDetail[index].amount.round())} ₫",
                            style: const TextStyle(color: Colors.red)),
                      ] else ...[
                        Text(
                            "+ ${oCcy.format(historyDetail[index].amount.round())} ₫",
                            style: const TextStyle(color: Colors.green)),
                      ]
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Mô tả: ",
                          style: TextStyle(color: Colors.grey)),
                      if (historyDetail[index].description == "") ... [
                        const Text("Không",
                          style: TextStyle(color: Colors.grey)),
                      ] else ... [
                        Text(historyDetail[index].description, maxLines: 1),
                      ]
                    ],
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      width: 70,
                      imageUrl: historyDetail[index]
                          .categoryTransactionGetDtos[0]
                          .logo,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
