// To parse this JSON data, do
//
//     final transactionHistory = transactionHistoryFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<TransactionHistory> transactionHistoryFromJson(String str) =>
    List<TransactionHistory>.from(
        json.decode(str).map((x) => TransactionHistory.fromJson(x)));

String transactionHistoryToJson(List<TransactionHistory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionHistory {
  TransactionHistory({
    required this.createdAt,
    required this.totalIncoming,
    required this.totalOutcoming,
    required this.transactionGetDtos,
  });

  String createdAt;
  double totalIncoming;
  double totalOutcoming;
  List<TransactionGetDto> transactionGetDtos;

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        totalIncoming:
            json["totalIncoming"].toDouble() == null ? null : json["totalIncoming"].toDouble(),
        totalOutcoming:
            json["totalOutcoming"].toDouble() == null ? null : json["totalOutcoming"].toDouble(),
        transactionGetDtos: List<TransactionGetDto>.from(json["transactionGetDtos"]
                .map((x) => TransactionGetDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt == null ? null : createdAt,
        "totalIncoming": totalIncoming == null ? null : totalIncoming,
        "totalOutcoming": totalOutcoming == null ? null : totalOutcoming,
        "transactionGetDtos": transactionGetDtos == null
            ? null
            : List<dynamic>.from(transactionGetDtos.map((x) => x.toJson())),
      };
}

class TransactionGetDto {
  TransactionGetDto({
    required this.transactionId,
    required this.walletId,
    required this.walletName,
    required this.amount,
    required this.description,
    required this.transactionType,
    required this.createdAt,
    required this.paymentType,
    required this.categoryTransactionGetDtos,
  });

  String transactionId;
  String walletId;
  String walletName;
  double amount;
  String description;
  String transactionType;
  String createdAt;
  String paymentType;
  List<CategoryTransactionGetDto> categoryTransactionGetDtos;

  factory TransactionGetDto.fromJson(Map<String, dynamic> json) =>
      TransactionGetDto(
        transactionId:
            json["transactionId"] == null ? null : json["transactionId"],
        walletId: json["walletId"] == null ? null : json["walletId"],
        walletName: json["walletName"] == null
            ? null
            : json["walletName"],
        amount: json["amount"].toDouble() == null ? null : json["amount"].toDouble(),
        description: json["description"] == null
            ? null
            : json["description"],
        transactionType:
            json["transactionType"] == null ? null : json["transactionType"],
        createdAt: json["createdAt"],
        paymentType: json["paymentType"] == null
            ? null
            : json["paymentType"],
        categoryTransactionGetDtos: List<CategoryTransactionGetDto>.from(
                json["categoryTransactionGetDtos"]
                    .map((x) => CategoryTransactionGetDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId == null ? null : transactionId,
        "walletId": walletId == null ? null : walletId,
        "walletName":
            walletName == null ? null : walletName,
        "amount": amount == null ? null : amount,
        "description":
            description == null ? null : description,
        "transactionType": transactionType == null ? null : transactionType,
        "createdAt": createdAt == null ? null : createdAt,
        "paymentType":
            paymentType == null ? null : paymentType,
        "categoryTransactionGetDtos": categoryTransactionGetDtos == null
            ? null
            : List<dynamic>.from(
                categoryTransactionGetDtos.map((x) => x.toJson())),
      };
}

class CategoryTransactionGetDto {
  CategoryTransactionGetDto({
    required this.name,
    required this.logo,
  });

  String name;
  String logo;

  factory CategoryTransactionGetDto.fromJson(Map<String, dynamic> json) =>
      CategoryTransactionGetDto(
        name: json["name"] == null ? null : json["name"],
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "logo": logo == null ? null : logo,
      };
}


