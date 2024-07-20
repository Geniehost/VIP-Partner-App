// import 'dart:wasm';

// ignore_for_file: unnecessary_import, camel_case_types, unused_local_variable, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import 'Add_delivery_boy.dart';

class dilevryPage extends StatefulWidget {
  const dilevryPage({Key? key}) : super(key: key);

  @override
  State<dilevryPage> createState() => _dilevryPageState();
}

class _dilevryPageState extends State<dilevryPage> {
  final x = Get.put(HomeGetData());

  @override
  void initState() {
    super.initState();
    x.getDeliveryListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        appBar: CustomAppbar(
          actionicon: Icons.add,
          center: true,
          centertext: 'Delivery Boy',
          onclick: () {
            Get.to(() => adddeliveryboy(type: "0"))!.then((value) {
              setState(() {});
              x.getDeliveryListApi();
            });
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                GetBuilder<HomeGetData>(
                    builder: (_) => FutureBuilder(
                          future: x.getDeliveryListApi(),
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
                                            return deliveryBoyList(users, i);
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

  deliveryBoyList(users, i) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
            color: WhiteColor,
            // border: Border.all(color: greycolor),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                        height: 52,
                        width: 52,
                        fadeInCurve: Curves.easeInCirc,
                        placeholder: "assets/skeleton.gif",
                        fit: BoxFit.cover,
                        image: Config.imageURLPath + users[i]["img"],
                        placeholderFit: BoxFit.cover),
                  ),
                  // ClipRRect(
                  //     borderRadius: BorderRadius.circular(12),
                  //     child: Image.network(
                  //         Config.imageURLPath + users[i]["img"],
                  //         height: 52,
                  //         width: 52,
                  //         fit: BoxFit.cover)),
                  SizedBox(width: Get.width * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.60,
                        child: Text(users[i]["partner_name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                fontSize: 17,
                                color: BlackColor)),
                      ),
                      SizedBox(height: 3),
                      Text("${users[i]["ccode"]}" "${users[i]["mobile"]}",
                          style: TextStyle(
                              fontFamily: "Gilroy Medium",
                              fontSize: 17,
                              color: greycolor))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: InkWell(
                onTap: () {
                  Get.to(() => adddeliveryboy(type: "1", dBoy: users[i]))!
                      .then((value) {
                    setState(() {});
                    x.getDeliveryListApi();
                  });
                },
                child: CircleAvatar(
                    radius: 16,
                    backgroundColor: BlackColor,
                    child: Icon(Icons.edit, color: WhiteColor, size: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
