// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, unnecessary_import, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import 'Add_cover_image.dart';

class coverimage extends StatefulWidget {
  const coverimage({Key? key}) : super(key: key);

  @override
  State<coverimage> createState() => _coverimageState();
}

class _coverimageState extends State<coverimage> {
  final x = Get.put(HomeGetData());
  bool isloading = false;
  var users;

  @override
  void initState() {
    super.initState();
    x.getCoverImageApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        appBar: CustomAppbar(
            actionicon: Icons.add,
            center: true,
            centertext: 'Cover Images',
            onclick: () {
              x.items.length > users.length
                  ? Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => addcoverimage()))
                      .then((value) {
                      setState(() {});
                      x.getCoverImageApi();
                    })
                  : ApiWrapper.showToastMessage("Already added");
            }),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: Get.height / 80),
            child: Column(
              children: [
                GetBuilder<HomeGetData>(
                    builder: (_) => FutureBuilder(
                          future: x.getCoverImageApi(),
                          builder: (ctx, AsyncSnapshot snap) {
                            if (snap.hasData) {
                              users = snap.data;
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: users.length,
                                          itemBuilder:
                                              (BuildContext context, i) {
                                            return coverimageList(users, i);
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

  coverimageList(user, i) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.grey)
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          user[i]["imglist"].length != 0
              ? Container(
                  height: Get.height / 15,
                  width: Get.width / 7,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage.assetNetwork(
                        fadeInCurve: Curves.easeInCirc,
                        placeholder: "assets/skeleton.gif",
                        fit: BoxFit.cover,
                        image: Config.imageURLPath +
                            user[i]["imglist"][0]["image_url"],
                        placeholderFit: BoxFit.cover),
                  ),
                )
              : SizedBox(
                  height: Get.height / 15,
                  width: Get.width / 7,
                ),
          Padding(
            padding: EdgeInsets.only(left: Get.width / 30),
            child: SizedBox(
              width: Get.width * 0.64,
              child: Text(user[i]["cat_name"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => addcoverimage(
                      type: "1",
                      recordID: user[i]["record_id"],
                      catid: user[i]["cat_id"],
                      cimage: user[i]["imglist"],
                      cname: user[i]["cat_name"]))!
                  .then((value) {
                setState(() {});
                x.getCoverImageApi();
              });
            },
            child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black,
                child: Icon(Icons.edit, color: Colors.white, size: 16)),
          )
        ],
      ),
    );
  }
}
