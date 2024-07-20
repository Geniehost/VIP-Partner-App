// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Service/AddSubCategory.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

class SubCatListPage extends StatefulWidget {
  const SubCatListPage({super.key});

  @override
  State<SubCatListPage> createState() => _SubCatListPageState();
}

class _SubCatListPageState extends State<SubCatListPage> {
  final x = Get.put(HomeGetData());
  String? subStatus;
  Color? statuscolor;

  @override
  void initState() {
    x.getSubCatApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 0), () {
    //   setState(() {});
    // });
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: CustomAppbar(
        actionicon: Icons.add,
        center: true,
        centertext: "Sub Category",
        onclick: () {
          Get.to(() => SubCategory())!.then((value) {
            setState(() {});
            x.getSubCatApi();
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
                        future: x.getSubCatApi(),
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
                                        child: Text(
                                            "Subcategory List Not Found",
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
    switch (users[i]["is_approve"]) {
      case "0":
        subStatus = "Waiting for admin approved";
        statuscolor = RedColor;
        break;
      case "1":
        subStatus = "Approved";
        statuscolor = greenColor;
        break;
      case "2":
        subStatus = "Reject by admin";
        statuscolor = RedColor;
        break;
      default:
        subStatus = "Waiting for admin approved";
        statuscolor = RedColor;
    }
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
                child: FadeInImage.assetNetwork(
                    fadeInCurve: Curves.easeInCirc,
                    placeholder: "assets/skeleton.gif",
                    fit: BoxFit.cover,
                    image: Config.imageURLPath + users[i]["sub_img"],
                    placeholderFit: BoxFit.cover),
              ),
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
                      child: Text(users[i]["cat_name"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15,
                              color: BlackColor,
                              fontFamily: "Gilroy Bold")),
                    ),
                    //! Edit Button
                    users[i]["is_approve"] == "1"
                        ? InkWell(
                            onTap: () {
                              Get.to(() => SubCategory(
                                      service: users[i], type: "1"))!
                                  .then((value) {
                                setState(() {});
                                x.getSubCatApi();
                              });
                            },
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: BlackColor,
                                child: Icon(Icons.edit,
                                    size: 16, color: WhiteColor)),
                          )
                        : const SizedBox(),
                  ],
                ),
                // const SizedBox(height: 6),
                SizedBox(
                  width: Get.width * 0.65,
                  child: Text(
                    users[i]["sub_title"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        color: greycolor,
                        fontFamily: "Gilroy Medium",
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(height: Get.height * 0.008),
                Text(
                  subStatus!,
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 13,
                      color: statuscolor,
                      fontFamily: "Gilroy Medium",
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
