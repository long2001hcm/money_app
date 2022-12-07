// To parse this JSON data, do
//
//     final balance = balanceFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Balance balanceFromJson(String str) => Balance.fromJson(json.decode(str));

String balanceToJson(Balance data) => json.encode(data.toJson());

class Balance {
  Balance({
    required this.totalBalance,
    required this.walletAvailableBalanceGetDtos,
  });

  double totalBalance;
  List<WalletAvailableBalanceGetDto> walletAvailableBalanceGetDtos;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        totalBalance: json["totalBalance"].toDouble(),
        walletAvailableBalanceGetDtos: List<WalletAvailableBalanceGetDto>.from(
            json["walletAvailableBalanceGetDtos"]
                .map((x) => WalletAvailableBalanceGetDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalBalance": totalBalance,
        "walletAvailableBalanceGetDtos": List<dynamic>.from(
            walletAvailableBalanceGetDtos.map((x) => x.toJson())),
      };
}

class WalletAvailableBalanceGetDto {
  WalletAvailableBalanceGetDto({
    required this.availableBalance,
    required this.walletId,
    required this.walletName,
  });

  double availableBalance;
  String walletId;
  String walletName;

  factory WalletAvailableBalanceGetDto.fromJson(Map<String, dynamic> json) =>
      WalletAvailableBalanceGetDto(
        availableBalance: json["availableBalance"],
        walletId: json["walletId"],
        walletName: json["walletName"] == null ? null : json["walletName"],
      );

  Map<String, dynamic> toJson() => {
        "availableBalance": availableBalance,
        "walletId": walletId,
        "walletName": walletName,
      };
}
