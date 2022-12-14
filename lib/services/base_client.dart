import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/balance.dart';
import '../models/balance_group.dart';
import '../models/bank.dart';
import '../models/category.dart';
import '../models/transaction_history.dart';
import '../models/user_info.dart';

const String baseUrl = 'http://longdo1-001-site1.dtempurl.com';
const String baseUrl2 = 'http://longdo2-001-site1.htempurl.com';
// const String baseUrl = 'https://3e1e-171-251-31-210.ngrok.io';
class BaseClient {
  var client = http.Client();
  Future<dynamic> getTransactionHistory(String userId, String period) async {
    var url = Uri.parse(
        "$baseUrl/Wallet/user/$userId/transaction-history?Period=$period");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      log(jsonString);
      return transactionHistoryFromJson(jsonString);
    }
  }

  Future<dynamic> getBalanceGroup(
      String userId, int type, String period) async {
    var url = Uri.parse(
        "$baseUrl/Wallet/user/$userId/balance-category-group?TransactionType=$type&Period=$period");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return balanceGroupFromJson(jsonString);
    }
  }

  Future<dynamic> getUserInfo(String userId) async {
    var url = Uri.parse("$baseUrl/AuthManagement/me/$userId");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return userFromJson(jsonString);
    }
  }
  Future<dynamic> getBanks() async {
    var url = Uri.parse("$baseUrl/BankConnection/bank-list");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return bankFromJson(jsonString);
    }
  }
  Future<dynamic> getCategories() async {
    var url = Uri.parse("$baseUrl/Category/all");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return categoryFromJson(jsonString);
    }
  }

  Future<dynamic> getBalance(String userId) async {
    var url = Uri.parse("$baseUrl/Wallet/user/$userId/total-balance");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return balanceFromJson(jsonString);
    }
  }

  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    var _headers = {
      "Authorization": token,
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var _payload = json.encode(object);
    var response = await client.post(url, body: _payload, headers: _headers);
    log(response.body);
    return response;
  }

  Future<dynamic> post2(String api, dynamic object) async {
    var url = Uri.parse(baseUrl2 + api);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    var _headers = {
      "Authorization": token,
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var _payload = json.encode(object);
    var response = await client.post(url, body: _payload, headers: _headers);
    log(response.body);
    return response;
  }

  Future<dynamic> put(String api) async {}

  Future<dynamic> delete(String api) async {}
}
