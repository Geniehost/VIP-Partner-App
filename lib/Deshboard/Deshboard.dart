// ignore_for_file: file_names, avoid_print, no_duplicate_case_values, sized_box_for_whitespace

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/AppModel/Dashbord/SubCatList.dart';
import 'package:service_provider/Booking/Booking.dart';
import 'package:service_provider/Booking/Tracking_order.dart';
import 'package:service_provider/Deshboard/Recent_added_Service.dart';
import 'package:service_provider/Service/SubCatListPage.dart';
import 'package:service_provider/Service/servicesListPage.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Utils/String.dart';
import 'package:service_provider/Service/TimeSloat/Time_sloatList.dart';
import 'package:service_provider/Service/Add_Service.dart';
import 'package:service_provider/WalletPage/Wallet.dart';

import '../Notification/Notificationpage.dart';
import '../Service/Coupon/CouponList.dart';
import 'Cover_image.dart';
import '../Service/DeliveryBoy/Delivery_boy.dart';

class Deshboard extends StatefulWidget {
  const Deshboard({super.key});

  @override
  State<Deshboard> createState() => _DeshboardState();
}

class _DeshboardState extends State<Deshboard> {
  final y = Get.put(HomeGetData());
  var sublist = Subcatlist();
  String? oStatus = '';
  Color? buttonColor;

  @override
  void initState() {
    y.homeDataGet();
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    OneSignal.initialize(Config.oneSignel);
    // OneSignal.shared.setAppId(Config.oneSignel);
    OneSignal.User.pushSubscription.addObserver((state) {});

    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.canRequest();

    OneSignal.Notifications.addPermissionObserver((state) {});

    // OneSignal.shared
    //     .promptUserForPushNotificationPermission()
    //     .then((accepted) {});

    // OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    //   print("Accepted OSPermissionStateChanges : $changes");
    // });

    OneSignal.User.addTagWithKey("store_id", getData.read("UserLogin")["id"]);
    // await OneSignal.shared.sendTag("user_id", getData.read("UserLogin")["id"]);
  }

  @override
  Widget build(BuildContext context) {
    print(vendorID);
    return SafeArea(
      child: Scaffold(
        backgroundColor: WhiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.hello,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Gilroy Medium",
                              color: greycolor)),
                      SizedBox(height: Get.height * 0.005),
                      Text(
                        getData.read("UserLogin")["title"] ?? "",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Gilroy Bold",
                            color: BlackColor),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const Note());
                    },
                    child: CircleAvatar(
                        backgroundColor: WhiteColor,
                        child:
                            Image.asset("assets/notification.png", height: 25)),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: SingleChildScrollView(
                    child: GetBuilder<HomeGetData>(
                  builder: (_) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          homeDashBord(
                              title: y.homeData?.reportData?.totalService
                                      .toString() ??
                                  "0",
                              subtitle: deshbord[0]["subtext"],
                              onTap: () {
                                Get.to(() => const services())!.then((value) {
                                  setState(() {});
                                  y.homeDataGet();
                                });
                              }),
                          homeDashBord(
                            title: y.homeData?.reportData?.totalTimeslot
                                    .toString() ??
                                "0",
                            subtitle: deshbord[1]["subtext"],
                            onTap: () {
                              Get.to(() => const Timesloat())!.then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          homeDashBord(
                            title: y.homeData?.reportData?.totalSubcat
                                    .toString() ??
                                "0",
                            subtitle: deshbord[2]["subtext"],
                            onTap: () {
                              //SubCatListPage
                              // Get.to(() => const SubCategory());
                              Get.to(() => const SubCatListPage())!
                                  .then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                          homeDashBord(
                            title: y.homeData?.reportData?.totalEarning
                                    .toString() ??
                                "0",
                            subtitle: deshbord[3]["subtext"],
                            onTap: () {},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          homeDashBord(
                            title: y.homeData?.reportData?.review.toString() ??
                                "0",
                            subtitle: deshbord[4]["subtext"],
                            onTap: () {},
                          ),
                          homeDashBord(
                            title: y.homeData?.reportData?.payout.toString() ??
                                "0",
                            subtitle: deshbord[5]["subtext"],
                            onTap: () {
                              Get.to(() => const Wallet())!.then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          homeDashBord(
                            title: y.homeData?.reportData?.totalCoupon
                                    .toString() ??
                                "0",
                            subtitle: deshbord[6]["subtext"],
                            onTap: () {
                              Get.to(() => const Coupen())!.then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                          homeDashBord(
                            title: y.homeData?.reportData?.totalPartner
                                    .toString() ??
                                "0",
                            subtitle: deshbord[7]["subtext"],
                            onTap: () {
                              Get.to(() => const dilevryPage())!.then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          homeDashBord(
                            title:
                                y.homeData?.reportData?.totalImage.toString() ??
                                    "0",
                            subtitle: deshbord[8]["subtext"],
                            onTap: () {
                              Get.to(() => const coverimage())!.then((value) {
                                setState(() {});
                                y.homeDataGet();
                              });
                            },
                          ),
                          homeDashBord(
                            title: y.homeData?.reportData?.totalOrders
                                    .toString() ??
                                "0",
                            subtitle: deshbord[9]["subtext"],
                            onTap: () {
                              Get.to(() => const Booking(),
                                  duration: Duration.zero);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.015),
                      y.homeData?.recentOrder != null
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Recent Order",
                                        style: TextStyle(
                                            fontFamily: "Gilroy Bold",
                                            fontSize: 15,
                                            color: BlackColor)),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const Booking())!
                                            .then((value) {
                                          setState(() {});
                                          y.homeDataGet();
                                        });
                                      },
                                      child: Text("View All",
                                          style: TextStyle(
                                              fontFamily: "Gilroy Bold",
                                              fontSize: 14,
                                              color: Darkblue)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.007),
                                //! --------- Rechent order ------------

                                currentorder()
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(height: Get.height * 0.02),
                      y.serviceList.isNotEmpty
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Recent added service",
                                        style: TextStyle(
                                            fontFamily: "Gilroy Bold",
                                            fontSize: 15,
                                            color: BlackColor)),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const Recentadded());
                                      },
                                      child: Text("View All",
                                          style: TextStyle(
                                              fontFamily: "Gilroy Bold",
                                              fontSize: 14,
                                              color: Darkblue)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.025),
                                //! --------------- Rechent Added Service --------------
                                GridView.count(
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 2,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: (0.9),
                                  shrinkWrap: true,
                                  children: List.generate(
                                      y.serviceList.length > 4
                                          ? 4
                                          : y.serviceList.length, (i) {
                                    return rechentAded(
                                        users: y.serviceList, i: i);
                                  }),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(height: Get.height * 0.015),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  homeDashBord({String? title, subtitle, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: Get.height * 0.11,
          width: Get.width * 0.44,
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: bgcolor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                    fontSize: 26, fontFamily: "Gilroy Bold", color: BlackColor),
              ),
              SizedBox(height: Get.height * 0.002),
              Text(
                subtitle ?? "",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Gilroy Medium",
                    color: BlackColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  currentorder() {
    var rOrder = y.homeData!.recentOrder;

    switch (rOrder!.status) {
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
        Get.to(() => Trackingorder(oID: rOrder.id))!.then((value) {
          setState(() {});
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 4),
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
                    Text(
                      provider.order,
                      style: TextStyle(
                          fontFamily: "Gilroy Bold",
                          color: brownColor,
                          fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text("#${rOrder.id}",
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            color: brownColor,
                            fontSize: 16))
                  ],
                ),
                Appbutton(
                    Width: Get.width * 0.4,
                    border: null,
                    buttoncolor: buttonColor,
                    buttontext: "$oStatus",
                    onclick: () {},
                    textcolor: WhiteColor)
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
                    rOrder.storeAddress.toString(),
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
                  dashColor: greycolor),
            ),
            Row(
              children: [
                Image.asset("assets/Maplocation.png",
                    height: 28, color: brownColor),
                SizedBox(width: Get.width * 0.02),
                SizedBox(
                  width: Get.width * 0.45,
                  child: Text(
                    rOrder.customerAddress.toString(),
                    style: TextStyle(
                        fontFamily: "Gilroy Medium",
                        color: BlackColor,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rOrder.distance.toString(),
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
                Text("${rOrder.total}" "${y.homeData!.currency} " "Earning",
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
                  "${rOrder.orderDate}",
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

  rechentAded({users, i}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: bgcolor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
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
          SizedBox(height: Get.height * 0.014),
          Container(
              width: Get.width * 0.50,
              child: Text(
                users[i]["cat_name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Gilroy Bold", fontSize: 15, color: BlackColor),
              )),
          SizedBox(height: Get.height * 0.008),
          SizedBox(
            width: Get.width * 0.50,
            child: Text(
              users[i]["subcat_name"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: "Gilroy Medium", fontSize: 11, color: greycolor),
            ),
          ),
        ]),
      ),
    );
  }
}
