// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Service/TimeSloat/Add_time_sloat.dart';

class Timesloat extends StatefulWidget {
  const Timesloat({super.key});

  @override
  State<Timesloat> createState() => _TimesloatState();
}

class _TimesloatState extends State<Timesloat> {
  final x = Get.put(HomeGetData());
  @override
  void initState() {
    x.timeSloatApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: CustomAppbar(
        actionicon: Icons.add,
        center: true,
        centertext: "Time Sloat",
        onclick: () {
          Get.to(() => Addtimesloat(type: "0"))!.then((value) {
            setState(() {});
            x.timeSloatApi();
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              GetBuilder<HomeGetData>(
                  builder: (_) => FutureBuilder(
                        future: x.timeSloatApi(),
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
                                        child: Text("Timeslot List Not Found",
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
                                          return timeList(users, i);
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

  timeList(users, i) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: yellowshadow),
                            child: Image.asset("assets/date.png", height: 15)),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.50,
                                  child: Text("${users[i]["cat_name"]}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: "Gilroy Bold",
                                          color: textcolor,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   width:Get.width * 0.3,
                            //   child: Text("Active",
                            //       style: TextStyle(
                            //           fontFamily: "Gilroy Medium",
                            //           color: greycolor,
                            //           fontSize: 15)),
                            // ),
                            SizedBox(
                              width: Get.width * 0.50,
                              child: Text(users[i]["cat_name"],
                                  style: TextStyle(
                                      fontFamily: "Gilroy Medium",
                                      color: greycolor,
                                      fontSize: 15)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //! ------------ Edit Button -----------
                        InkWell(
                          onTap: () {
                            Get.to(() => Addtimesloat(
                                    type: "1", timesloat: users[i]))!
                                .then((value) {
                              setState(() {});
                              x.timeSloatApi();
                            });
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: BlackColor,
                              child: Icon(Icons.edit,
                                  size: 16, color: WhiteColor)),
                        ),
                        SizedBox(height: Get.height * 0.008),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: Get.width * 0.20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: bgcolor),
                            child: Center(
                                child: Text(
                                    users[i]["day_type"] != "1"
                                        ? "Current"
                                        : "Next",
                                    style: TextStyle(
                                        fontFamily: "Gilroy Medium",
                                        fontSize: 15,
                                        color: textcolor))),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
