// To parse this JSON data, do
//
//     final balanceGroup = balanceGroupFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<BalanceGroup> balanceGroupFromJson(String str) => List<BalanceGroup>.from(json.decode(str).map((x) => BalanceGroup.fromJson(x)));

String balanceGroupToJson(List<BalanceGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BalanceGroup {
    BalanceGroup({
        required this.categoryName,
        required this.categoryId,
        required this.categoryLogo,
        required this.totalBalance,
    });

    String categoryName;
    int categoryId;
    String categoryLogo;
    double totalBalance;

    factory BalanceGroup.fromJson(Map<String, dynamic> json) => BalanceGroup(
        categoryName: json["categoryName"] == null ? null : json["categoryName"],
        categoryId: json["categoryId"] == null ? null : json["categoryId"],
        categoryLogo: json["categoryLogo"] == null ? null : json["categoryLogo"],
        totalBalance: json["totalBalance"] == null ? null : json["totalBalance"],
    );

    Map<String, dynamic> toJson() => {
        "categoryName": categoryName == null ? null : categoryName,
        "categoryId": categoryId == null ? null : categoryId,
        "categoryLogo": categoryLogo == null ? null : categoryLogo,
        "totalBalance": totalBalance == null ? null : totalBalance,
    };
}
