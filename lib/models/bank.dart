// To parse this JSON data, do
//
//     final bank = bankFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Bank> bankFromJson(String str) =>
    List<Bank>.from(json.decode(str).map((x) => Bank.fromJson(x)));

String bankToJson(List<Bank> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bank {
  Bank({
    required this.id,
    required this.bankName,
    required this.logo,
  });

  String id;
  String bankName;
  String logo;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"] == null ? null : json["id"],
        bankName: json["bankName"] == null ? null : json["bankName"],
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "bankName": bankName == null ? null : bankName,
        "logo": logo == null ? null : logo,
      };
}
