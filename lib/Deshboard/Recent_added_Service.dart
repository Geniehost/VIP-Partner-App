// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Service/Add_Service.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

class Recentadded extends StatefulWidget {
  const Recentadded({super.key});

  @override
  State<Recentadded> createState() => _RecentaddedState();
}

class _RecentaddedState extends State<Recentadded> {
  final y = Get.put(HomeGetData());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: CustomAppbar(
        actionicon: null,
        center: true,
        redi: 0,
        centertext: "Recent Added Service",
        onclick: () {},
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: (0.999),
          shrinkWrap: true,
          children: List.generate(y.serviceList.length, (i) {
            return rechentAded(users: y.serviceList, i: i);
          }),
        ),
      ),
    );
  }

  rechentAded({users, i}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: WhiteColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(Config.imageURLPath + users[i]["img"],
                        fit: BoxFit.cover, height: 110, width: Get.width),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: WhiteColor),
                          child: Center(
                            child: Text(
                                "${y.homeData!.currency}"
                                "${users[i]["price"]}",
                                style: TextStyle(
                                    fontFamily: "Gilroy Medium",
                                    fontSize: 12,
                                    color: BlackColor)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => Servicedetails(
                                      service: users[i], type: "1"))!
                                  .then((value) {
                                setState(() {
                                  y.homeDataGet();
                                  y.serviceList;
                                });
                              });
                            },
                            child: CircleAvatar(
                                radius: 18,
                                backgroundColor: BlackColor,
                                child: Icon(Icons.edit,
                                    size: 18, color: WhiteColor)),
                          ),
                        )
                      ],
                    )
                  ],
                )),
            SizedBox(height: Get.height * 0.012),
            SizedBox(
              width: Get.width * 0.50,
              child: Text(
                users[i]["cat_name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Gilroy Bold", fontSize: 15, color: BlackColor),
              ),
            ),
            SizedBox(height: Get.height * 0.008),
            SizedBox(
              width: Get.width * 0.50,
              child: Text(
                users[i]["subcat_name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Gilroy Medium",
                    fontSize: 11,
                    color: greycolor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
