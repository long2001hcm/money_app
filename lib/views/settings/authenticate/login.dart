import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_app/views/settings/authenticate/register.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/login_user.dart';
import '../../../../services/base_client.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: HexColor("#e48d7a"),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: HexColor("#272727"),
        elevation: 0,
        toolbarHeight: 60,
      ),
      backgroundColor: HexColor("#272727"),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              right: 35,
              left: 35,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Xin chào!!",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: HexColor("#e48d7a")),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: HexColor("#e48d7a")),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Mật khẩu',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    color: HexColor("#e48d7a"),
                    onPressed: () async {
                      var user = LoginUser(
                          email: emailController.text,
                          password: passwordController.text);
                      var response = await BaseClient()
                          .post('/AuthManagement/login', user)
                          .catchError((err) {});
                      Map<String, dynamic> jsonData =
                          json.decode(response.body) as Map<String, dynamic>;
                      if (jsonData['success']) {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                title: Text("Success"),
                                content: Text("Đăng nhập thành công!!!")),
                            barrierDismissible: true);
                        var jsonResponse = jsonDecode(response.body);
                        String token = jsonResponse['token'];
                        String userId = jsonResponse['userId'];
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('token', token);
                        await prefs.setString('userId', userId);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                title: Text("Fail"),
                                content: Text(
                                    "Đăng nhập thất bại!!!\n\nVui lòng kiểm tra lại tài khoản và mật khẩu")),
                            barrierDismissible: true);
                      }
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyRegister(),
                        ));
                  },
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: const Text(
                //     'Quên mật khẩu',
                //     style: TextStyle(
                //       decoration: TextDecoration.underline,
                //       fontSize: 15,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
