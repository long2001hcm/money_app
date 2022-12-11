import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/balance.dart';
import '../models/category.dart';
import '../models/user_info.dart';

const String baseUrl = 'http://longdo1-001-site1.dtempurl.com';
// const String baseUrl = 'https://3e1e-171-251-31-210.ngrok.io';
class BaseClient {
  var client = http.Client();   
  Future<dynamic> getUserInfo(String userId) async {
    var url = Uri.parse("$baseUrl/AuthManagement/me/$userId");
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return userFromJson(jsonString);
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
      "content-type":"application/json"
    };
    var _payload = json.encode(object);
    var response = await client.post(url, body: _payload, headers: _headers);
    log(response.body);
    return response;
  }

  Future<dynamic> put(String api) async {}

  Future<dynamic> delete(String api) async {}
  
}