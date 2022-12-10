import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/category.dart';
import '../../services/base_client.dart';

class CategoryView extends StatefulWidget {
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  Future<List<Category>>? categories;
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    if (mounted) {
      setState(() {
        categories = fetchCategories();
      });
    }
  }

  Future<List<Category>> fetchCategories() async {
    return await BaseClient().getCategories().catchError((err) {
      print(err);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Loại giao dịch"),
            backgroundColor: HexColor("#272727"),
            leading: IconButton(
              color: HexColor("#e48d7a"),
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: categoryInfo(),
      ),
    );
  }
  FutureBuilder<List<Category>> categoryInfo() {
    return FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return categoryDetail(snapshot.data!);
          }

          return SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                  child:
                      CircularProgressIndicator(color: HexColor("#e48d7a"))));
        });
  }

  ListView categoryDetail(List<Category> categories) {
    return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: categories.length,
          itemBuilder: (BuildContext c, int index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, categories[index]);
                  },
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                        children: [
                          Image.network(categories[index].logo, width: 70,),
                          const SizedBox(width: 15),
                          Text(
                            categories[index]
                                .name,
                            style:
                                const TextStyle(color: Colors.grey, fontSize: 17),
                          ),
                        ]),
                  ),
                ),
                if (categories[index].subCategories.length > 0) ...[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: categories[index].subCategories.length,
                    itemBuilder: (BuildContext c, int index2) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context, categories[index].subCategories[index2]);
                          },
                          child: Container(
                            height: 80,
                            margin:
                                const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            padding:
                                const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                              Image.network(
                                categories[index].subCategories[index2].logo,
                                width: 50,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                categories[index].subCategories[index2].name,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 17),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
                ],
              ],
              
            );
          });
  }
}
