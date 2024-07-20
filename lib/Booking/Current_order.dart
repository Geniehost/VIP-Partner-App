// ignore_for_file: file_names, no_duplicate_case_values

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Booking/Tracking_order.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Utils/String.dart';

class Currentorder extends StatefulWidget {
  const Currentorder({super.key});

  @override
  State<Currentorder> createState() => _CurrentorderState();
}

class _CurrentorderState extends State<Currentorder> {
  final x = Get.put(HomeGetData());

  String? oStatus = '';
  Color? buttonColor;
  @override
  void initState() {
    super.initState();
    x.getOrderListApi("recent");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              GetBuilder<HomeGetData>(
                  builder: (_) => FutureBuilder(
                        future: x.getOrderListApi("recent"),
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
                                        child: Text("Order  Not Found!!!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16))),
                                  ])
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: users.length,
                                    itemBuilder: (ctx, i) {
                                      return currentorder(users, i);
                                    },
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

  currentorder(user, i) {
    switch (user[i]["status"]) {
      case "Accepted":
        oStatus = provider.accept;
        buttonColor = gradientColor;
        break;
      case "Pending":
        oStatus = provider.pending;
        buttonColor = orangeColor;
        break;
      case "Ongoing":
        oStatus = provider.ongoing;
        buttonColor = lightyello;
        break;
      case "Pickup Order":
        oStatus = provider.pickup;
        buttonColor = gradientColor;
        break;
      case "Pickup Order":
        oStatus = provider.pickupor;
        buttonColor = RedColor;
        break;
      default:
    }
    return GestureDetector(
      onTap: () {
        Get.to(() => Trackingorder(oID: user[i]["id"]))!.then((value) {
          x.getOrderListApi("recent");
          setState(() {});
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Greycolor),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(provider.order,
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            color: brownColor,
                            fontSize: 16)),
                    const SizedBox(width: 4),
                    Text("#${user[i]["id"]}",
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            color: brownColor,
                            fontSize: 16))
                  ],
                ),
                SizedBox(
                    height: 34,
                    child: Appbutton(
                        Width: Get.width * 0.32,
                        border: null,
                        buttoncolor: buttonColor,
                        buttontext: "$oStatus",
                        onclick: () {},
                        textcolor: WhiteColor))
              ],
            ),
            SizedBox(height: Get.height * 0.008),
            Row(
              children: [
                Image.asset("assets/metrize.png",
                    height: 28, color: yelloColor),
                SizedBox(width: Get.width * 0.02),
                SizedBox(
                  width: Get.width * 0.45,
                  child: Text(
                    user[i]["store_address"],
                    style: TextStyle(
                        fontFamily: "Gilroy Medium",
                        color: BlackColor,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 14, top: 2, bottom: 2),
                child: Dash(
                    direction: Axis.vertical,
                    length: 20,
                    dashThickness: 2,
                    dashLength: 8,
                    dashColor: greycolor)),
            Row(
              children: [
                Image.asset("assets/Maplocation.png",
                    height: 28, color: brownColor),
                SizedBox(width: Get.width * 0.02),
                SizedBox(
                  width: Get.width * 0.45,
                  child: Text(user[i]["customer_address"],
                      style: TextStyle(
                          fontFamily: "Gilroy Medium",
                          color: BlackColor,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis)),
                )
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user[i]["distance"],
                    style: TextStyle(
                        fontFamily: "Gilroy Medium",
                        color: BlackColor,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis)),
                DottedLine(
                    direction: Axis.horizontal,
                    lineLength: 6,
                    lineThickness: 2.0,
                    dashColor: BlackColor),
                Text("${user[i]["total"]}" "${x.homeData!.currency} " "Earning",
                    style: TextStyle(
                        fontFamily: "Gilroy Medium",
                        color: BlackColor,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis)),
                DottedLine(
                    direction: Axis.horizontal,
                    lineLength: 6,
                    lineThickness: 2.0,
                    dashColor: BlackColor),
                Text(
                  user[i]["order_date"],
                  style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: BlackColor,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
