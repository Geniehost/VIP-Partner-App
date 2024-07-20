// import 'dart:wasm';

// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import 'Add_coupen.dart';

class Coupen extends StatefulWidget {
  const Coupen({Key? key}) : super(key: key);

  @override
  State<Coupen> createState() => _CoupenState();
}

class _CoupenState extends State<Coupen> {
  final x = Get.put(HomeGetData());

  @override
  void initState() {
    x.getCouponListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        appBar: CustomAppbar(
            actionicon: Icons.add,
            center: true,
            centertext: 'Coupens',
            redi: 17,
            onclick: () {
              Get.to(() => addcoupen())!.then((value) {
                setState(() {});
                x.getCouponListApi();
              });
            }),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Column(
              children: [
                GetBuilder<HomeGetData>(
                    builder: (_) => FutureBuilder(
                          future: x.getCouponListApi(),
                          builder: (ctx, AsyncSnapshot snap) {
                            if (snap.hasData) {
                              var users = snap.data;
                              return users.length == 0
                                  ? Column(children: [
                                      SizedBox(height: Get.height * 0.18),
                                      Image(
                                          image: const AssetImage(
                                              "assets/emptyList1.png"),
                                          height: Get.height * 0.20),
                                      SizedBox(height: Get.height * 0.04),
                                      const Center(
                                          child: Text("Coupon List Not Found",
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
                                            return couponList(users, i);
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
        ));
  }

  couponList(users, i) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
            color: WhiteColor,
            // border: Border.all(color: BlackColor),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: yellowshadow),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage.assetNetwork(
                            fadeInCurve: Curves.easeInCirc,
                            placeholder: "assets/skeleton.gif",
                            fit: BoxFit.cover,
                            image: Config.imageURLPath + users[i]["coupon_img"],
                            placeholderFit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${x.homeData!.currency}" + users[i]["min_amt"],
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: textcolor,
                                fontSize: 18)),
                        SizedBox(
                          width: Get.width * 0.4,
                          child: Text(users[i]["title"],
                              style: TextStyle(
                                  fontFamily: "Gilroy Medium",
                                  color: greycolor,
                                  fontSize: 15)),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => addcoupen(type: "1", service: users[i]))!
                        .then((value) {
                      setState(() {});
                      x.getCouponListApi();
                    });
                  },
                  child: CircleAvatar(
                      radius: 16,
                      backgroundColor: BlackColor,
                      child: Icon(Icons.edit, color: WhiteColor, size: 16)),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Text("Exp Date:",
                      style: TextStyle(
                          fontFamily: "Gilroy Medium",
                          color: greycolor,
                          fontSize: 14)),
                  Text(users[i]["expire_date"],
                      style: TextStyle(
                          fontFamily: "Gilroy Medium",
                          color: greycolor,
                          fontSize: 13)),
                ],
              ),
              SizedBox(
                height: 36,
                child: Appbutton(
                    Width: Get.width * 0.30,
                    border: null,
                    buttoncolor: BlackColor,
                    buttontext: users[i]["coupon_code"],
                    onclick: () {},
                    textcolor: WhiteColor),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
