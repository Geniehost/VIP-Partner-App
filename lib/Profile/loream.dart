// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Loream extends StatefulWidget {
  final String? title;
  final String? description;
  const Loream({Key? key, this.description, this.title}) : super(key: key);
  @override
  State<Loream> createState() => _LoreamState();
}

class _LoreamState extends State<Loream> {
  String? text;
  List<DynamicPageData> dynamicPageDataList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sp;
    return Scaffold(
      backgroundColor: WhiteColor,
      body: Column(
        children: [
          SizedBox(height: Get.height / 20),
          Row(
            children: [
              SizedBox(width: Get.width / 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: BlackColor),
                    SizedBox(width: Get.width / 80),
                    Text(
                      widget.title!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Gilroy Medium',
                          color: BlackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.height / 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                    child: Column(children: [
                      (widget.description != null)
                          ? HtmlWidget(widget.description ?? "",
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: Get.height / 50,
                                  fontFamily: 'Gilroy Normal'))
                          : Text("",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Get.height / 50,
                                  fontFamily: 'Gilroy Normal')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicPageData {
  DynamicPageData(this.title, this.description);

  String? title;
  String? description;

  DynamicPageData.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description};
  }
}
