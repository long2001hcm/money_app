import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:money_app/views/settings/authenticate/login.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:money_app/views/settings/balance_group_detail.dart';
import 'package:money_app/views/settings/transaction_history.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../models/balance_group.dart';
import '../../models/user_info.dart';
import '../../services/base_client.dart';

void main() {
  runApp(Settings());
}

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<User>? user;
  Future<List<BalanceGroup>>? balanceGroupIncoming;
  Future<List<BalanceGroup>>? balanceGroupOutcoming;
  String userId = "";
  Map<String, double> dataMap = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() {
    if (mounted && userId != '') {
      user = fetchUser();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat("MM/dd/yyyy");
      final String formatted = formatter.format(now);
      balanceGroupIncoming = fetchBalanceGroupIncoming(formatted);
      balanceGroupOutcoming = fetchBalanceGroupOutcoming(formatted);
    }
  }

  Future<List<BalanceGroup>> fetchBalanceGroupIncoming(String formatted) async {
    return await BaseClient()
        .getBalanceGroup(userId, 0, formatted)
        .catchError((err) {
      print(err);
    });
  }

  Future<List<BalanceGroup>> fetchBalanceGroupOutcoming(
      String formatted) async {
    return await BaseClient()
        .getBalanceGroup(userId, 1, formatted)
        .catchError((err) {
      print(err);
    });
  }

  Future<User> fetchUser() async {
    return await BaseClient().getUserInfo(userId).catchError((err) {
      print(err);
    });
  }

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("MoneyApp"),
          backgroundColor: HexColor("#272727"),
        ),
        body: SingleChildScrollView(child: checkLogin(context)),
      ),
    );
  }

  FutureBuilder<SharedPreferences> checkLogin(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: _getPrefs(),
        builder: (context1, snapshot) {
          if (snapshot.hasData) {
            userId = snapshot.data!.getString('userId') ?? '';
            if (userId == '') {
              return settingView();
            }
            getData();
            return userInfo();
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  FutureBuilder<User> userInfo() {
    return FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return userDetail(snapshot.data!);
          }
          if (snapshot.hasData) {
            return userDetail(snapshot.data!);
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  FutureBuilder<List<BalanceGroup>> balanceOutcomeInfo() {
    double total = 0.0;
    Map<String, double> dataMap = {};
    return FutureBuilder<List<BalanceGroup>>(
        future: balanceGroupOutcoming,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              dataMap[snapshot.data![i].categoryName] =
                  snapshot.data![i].totalBalance;
              total += snapshot.data![i].totalBalance;
            }
            if (dataMap.isEmpty) {
              return const Text(
                  "Chưa có dữ liệu thống kê cho tiêu dùng tháng này.");
            }
            return balanceDetail(snapshot.data!, dataMap, total, "Tiêu dùng");
          }

          return const SizedBox();
        });
  }

  FutureBuilder<List<BalanceGroup>> balanceIncomeInfo() {
    double total = 0.0;
    return FutureBuilder<List<BalanceGroup>>(
        future: balanceGroupIncoming,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              dataMap[snapshot.data![i].categoryName] =
                  snapshot.data![i].totalBalance;
              total += snapshot.data![i].totalBalance;
            }
            if (dataMap.isEmpty) {
              return const Text(
                  "Chưa có dữ liệu thống kê cho thu nhập tháng này.");
            }
            return balanceDetail(snapshot.data!, dataMap, total, "Thu nhập");
          }

          return const SizedBox();
        });
  }

  GestureDetector balanceDetail(List<BalanceGroup> balanceGroup,
      Map<String, double> dataMap, double total, String type) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BalanceGroupDetail(balanceGroup, total, type),
            ));
      }),
      child: Container(
        height: 210,
        child: PieChart(
          dataMap: dataMap,
          centerText: type,
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: false,
          ),
        ),
      ),
    );
  }

  Column userDetail(User user) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào ${user.userName}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#e48d7a"),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('token', "");
                      await prefs.setString('userId', "");
                      setState(() {});
                    },
                    child: const Text('Đăng xuất'),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#e48d7a"),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistory(userId),
                      ));
                },
                child: const Text('Lịch sử giao dịch'),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          padding: const EdgeInsets.all(15),
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
          child: Column(
            children: [
              const Text(
                "Thống kê tháng này",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 15),
              balanceOutcomeInfo(),
              const SizedBox(height: 15),
              balanceIncomeInfo(),
              if (dataMap.isNotEmpty) ... [
                const Text("Nhấn để xem chi tiết",
                    style: TextStyle(color: Colors.grey)),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Column settingView() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 200,
                child: Text(
                  "Chào mừng đến với Money App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#e48d7a"),
                ),
                child: const Text('Đăng nhập'),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => const MyLogin(),
                  ))
                      .then(
                    (value) {
                      setState(() {});
                    },
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 240),
        const Center(child: Text("Bạn chưa đăng nhập!!!")),
      ],
    );
  }
}
