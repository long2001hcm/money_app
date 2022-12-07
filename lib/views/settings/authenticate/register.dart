import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/user.dart';
import '../../../services/base_client.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  bool _validate = false;
  TextEditingController userNameController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  late DateTime dateOfBirth; 
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController reEnterPasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      // ),
      child: Scaffold(
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
              padding: const EdgeInsets.only(right: 35, left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Đăng ký",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                    ),
                    
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: userNameController,
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
                      hintText: 'Tên đăng nhập',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: firstNameController,
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
                      hintText: 'Tên',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: lastNameController,
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
                      hintText: 'Họ',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  DateTimeFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.grey),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        suffixIcon: const Icon(Icons.event_note),
                        hintText: 'Ngày sinh',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                          dateOfBirth = value;
                      },
                    ),
                  const SizedBox(
                    height: 40,
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
                    height: 40,
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
                  TextField(
                      controller: reEnterPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: _validate ? 'Nhập sai' : null,
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
                        hintText: 'Nhập lại mật khẩu',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            color: HexColor("#e48d7a"),
                            onPressed: () async {
                              if (passwordController.text == reEnterPasswordController.text) {
                                setState(() {
                                  _validate = false;
                                });
                                var user = User(
                                  username: userNameController.text,  
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  dob: dateOfBirth,
                                  email: emailController.text,
                                  password: passwordController.text
                                );
                                var response = await BaseClient().post('/AuthManagement/register', user).catchError((err) {});
                                print(response);
                                Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
                                if (jsonData['success']) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => const AlertDialog(
                                          title: Text("Success"),
                                          content:
                                              Text("Đăng ký thành công!!!")),
                                      barrierDismissible: true);
                                  var jsonResponse = jsonDecode(response.body);
                                  String token = jsonResponse['token'];
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('token', token);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          title: const Text("Fail"),
                                          content: Text(
                                              "Đăng ký thất bại!!!\n\n${jsonData['errors'].toString().substring(1, jsonData['errors'].toString().length-1)}")),
                                      barrierDismissible: true);
                                }
                              } else {
                                setState(() {
                                  _validate = true;
                                });
                              }
                            },
                            icon: const Icon(Icons.check),
                          ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                ]),
            ),
          ),
        ]),
      ),
    );
  }
}
