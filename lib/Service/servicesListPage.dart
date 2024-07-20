// ignore_for_file: camel_case_types, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Service/Add_Service.dart';

class services extends StatefulWidget {
  final String? type;
  const services({super.key, this.type});

  @override
  State<services> createState() => _servicesState();
}

class _servicesState extends State<services> {
  final x = Get.put(HomeGetData());

  @override
  void initState() {
    x.getServiceApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: CustomAppbar(
        leading: widget.type != "Hide" ? null : SizedBox(),
        actionicon: Icons.add,
        center: true,
        centertext: "Services",
        onclick: () {
          Get.to(() => Servicedetails())!.then((value) {
            setState(() {});
            x.getServiceApi();
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              GetBuilder<HomeGetData>(
                  builder: (_) => FutureBuilder(
                        future: x.getServiceApi(),
                        builder: (ctx, AsyncSnapshot snap) {
                          if (snap.hasData) {
                            var users = snap.data;
                            return users.length == 0
                                ? Column(children: [
                                    SizedBox(height: Get.height * 0.18),
                                    Image(
                                        image:
                                            AssetImage("assets/emptyList1.png"),
                                        height: Get.height * 0.20),
                                    SizedBox(height: Get.height * 0.04),
                                    const Center(
                                        child: Text("Service List Not Found",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16))),
                                  ])
                                : SizedBox(
                                    height: Get.height * 0.90,
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: Get.height * 0.08),
                                        shrinkWrap: true,
                                        itemCount: users.length,
                                        itemBuilder: (context, i) {
                                          return catSubList(users, i);
                                        }),
                                  );
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: Get.height * 0.35),
                                Center(child: isLoadingIndicator()),
                              ],
                            );
                          }
                        },
                      ))
            ],
          ),
        ),
      ),
    );
  }

  catSubList(users, i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: WhiteColor),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              height: 75,
              width: 75,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(Config.imageURLPath + users[i]["img"],
                      fit: BoxFit.cover)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.60,
                      child: Text(
                        users[i]["title"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15,
                            color: BlackColor,
                            fontFamily: "Gilroy Bold"),
                      ),
                    ),
                    //! Edit Button
                    InkWell(
                      onTap: () {
                        Get.to(() =>
                                Servicedetails(service: users[i], type: "1"))!
                            .then((value) {
                          setState(() {
                            x.getServiceApi();
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: CircleAvatar(
                            radius: 16,
                            backgroundColor: BlackColor,
                            child:
                                Icon(Icons.edit, size: 16, color: WhiteColor)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: Get.width * 0.65,
                  child: Text(
                    users[i]["service_desc"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        color: greycolor,
                        fontFamily: "Gilroy Medium",
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${x.homeData?.currency}${users[i]["price"]}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Darkblue,
                              fontFamily: "Gilroy Bold"),
                        ),
                        // SizedBox(
                        //     width:Get.width * 0.07),
                        // Image.asset("assets/star.png", height: 20),
                        // const SizedBox(width: 2),
                        // Text(
                        //   "4.2".toString(),
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       color: Darkblue,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // Text(
                        //   "(186Reviews)".toString(),
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       color: greycolor,
                        //       fontFamily: "Gilroy Medium"),
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.005),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
