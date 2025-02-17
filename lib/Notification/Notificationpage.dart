// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, depend_on_referenced_packages, library_private_types_in_public_api, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/Colors.dart';

import '../Api/ApiWrapper.dart';
import '../Utils/AppWidget.dart';

class Note extends StatefulWidget {
  const Note({Key? key}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  List notificationList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    notificationListApi();
  }

  // getdarkmodepreviousstate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool? previusstate = prefs.getBool("setIsDark");
  //   if (previusstate == null) {
  //     notifire.setIsDark = false;
  //   } else {
  //     notifire.setIsDark = previusstate;
  //   }
  // }

  Future notificationListApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.notification);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (request.statusCode == 200) {
        return response["NotificationData"];
      } else {}
    } catch (e) {
      print("Exeption----- $e");
    }
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "m" : "m"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "week"}";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "day"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "h" : "h"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "min"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: WhiteColor,
        title: const Text("Notification",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: FutureBuilder(
          future: notificationListApi(),
          builder: (ctx, AsyncSnapshot snap) {
            if (snap.hasData) {
              var notif = snap.data;

              return notif.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Image(
                              image: const AssetImage("assets/emptyNoti.png"),
                              height: Get.height * 0.14),
                          SizedBox(height: Get.height * 0.02),
                          Center(
                            child: SizedBox(
                              width: Get.width * 0.70,
                              child: const Text(
                                  "We’ll let you know when we get news for you.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Bold',
                                  )),
                            ),
                          ),
                        ])
                  : SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: notif.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          var notific = notif.reversed.toList();
                          DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(notific[i]["datetime"]);
                          return notificationslist(
                            title: notific[i]["title"],
                            discription: notific[i]["description"],
                            time: timeAgo(tempDate),
                          );
                        },
                      ),
                    );
            } else {
              return Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.36),
                      isLoadingIndicator(),
                    ]),
              );
            }
          }),
    );
  }

  Widget notificationslist({String? title, String? discription, String? time}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
      child: Column(children: [
        SizedBox(height: Get.height / 100),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Image.asset("assets/Notification1.png",
                  color: Colors.black, height: Get.height / 34)),
          SizedBox(width: Get.width / 30),
          Container(
            width: Get.width / 1.8,
            color: Colors.transparent,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title!,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Gilroy_Bold',
                      fontSize: Get.height / 55)),
              SizedBox(height: Get.height / 200),
              Text(discription!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontFamily: 'Gilroy_Medium',
                      fontSize: Get.height / 60)),
            ]),
          ),
          const Spacer(),
          Text(
            time!,
            style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontFamily: 'Gilroy_Medium',
                fontSize: Get.height / 60),
          ),
        ]),
        SizedBox(height: Get.height / 100),
        Divider(
          thickness: 0.6,
          color: Colors.grey.shade300,
        ),
      ]),
    );
  }
}
