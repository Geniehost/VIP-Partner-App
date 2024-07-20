// ignore_for_file: file_names, sized_box_for_whitespace, non_constant_identifier_names, unnecessary_question_mark, no_duplicate_case_values, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, unused_field, avoid_print, prefer_final_fields

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Service/DeliveryBoy/Add_delivery_boy.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Utils/String.dart';

class Trackingorder extends StatefulWidget {
  final String? oID;
  const Trackingorder({super.key, this.oID});

  @override
  State<Trackingorder> createState() => _TrackingorderState();
}

class _TrackingorderState extends State<Trackingorder> {
  final x = Get.put(HomeGetData());

  final List<String> items = [];
  String? selectedValue;
  String? oStatus = '';
  Color? butColor;

  bool reject = false;
  int selectedIndex = 0;
  int _value = 0;
  String border = "";
  Map? orderData;
  bool isLoading = false;
  var selectedRadioTile;
  final note = TextEditingController();
  String? rejectmsg = '';
  String? selectradio = "0";
  List partnerlist = [];
  String? riderID;

  @override
  void initState() {
    super.initState();
    getOrderDetailsApi(widget.oID);
    x.getDeliveryListApi().then((value) {
      partnerlist = value;
      value.forEach((e) {
        items.add(e["partner_name"]);
        print(e["partner_name"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        cColor: WhiteColor,
        centertext: "#${widget.oID ?? ""}",
        center: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (orderData?["order_flow_id"] == "0") ...{
              Button(
                  Width: Get.width * 0.28,
                  buttontext: "Reject",
                  buttoncolor: redgradient,
                  onclick: () {
                    ticketCancell(widget.oID);
                  }),
            },
            if (orderData?["order_flow_id"] == "0") ...{
              Button(
                  Width: Get.width * 0.66,
                  buttontext: "Confirm Order",
                  buttoncolor: gradientColor,
                  onclick: () {
                    acceptOrderApi(widget.oID);
                  }),
            },
            if (orderData?["order_flow_id"] == "1") ...{
              Button(
                  Width: Get.width * 0.66,
                  buttontext: "Assign to Service partner",
                  buttoncolor: gradientColor,
                  onclick: Orderbottomsheet),
            },
            if (orderData?["order_flow_id"] == "3") ...{
              Button(
                  Width: Get.width * 0.66,
                  buttontext: "Wait for Service partner",
                  buttoncolor: gradientColor,
                  onclick: () {
                    ApiWrapper.showToastMessage(
                        "Wait for Service partner decision");
                  }),
            },
            if (orderData?["order_flow_id"] == "4") ...{
              Button(
                  Width: Get.width * 0.66,
                  buttontext: "Service partner on the way",
                  buttoncolor: gradientColor,
                  onclick: () {
                    ApiWrapper.showToastMessage("Service partner on the way");
                  }),
            },
            if (orderData?["order_flow_id"] == "5") ...{
              Button(
                  Width: Get.width * 0.66,
                  buttontext: "Assign to Service partner",
                  buttoncolor: gradientColor,
                  onclick: Orderbottomsheet),
            },
            if (orderData?["order_flow_id"] == "2") ...{
              Container(
                height: Get.height * 0.06,
                width: Get.width * 0.94,
                decoration: BoxDecoration(
                    color: orangeColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(orderData?["comment_reject"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gilroy Medium',
                            fontSize: 16)),
                  ],
                ),
              ),
            }
          ],
        ),
      ),
      backgroundColor: WhiteColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: !isLoading
                ? Column(
                    children: [
                      ListView.builder(
                          itemCount: orderData!["Order_Product_Data"].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return orderDetailslist(
                                orderData!["Order_Product_Data"], i);
                          }),
                      SizedBox(height: Get.height * 0.03),
                      orderDetail(
                        date:
                            "Date: ${orderData!["order_date"]} | ${orderData!["service_time"]}",
                        status: oStatus,
                        bColor: butColor,
                        onTap: () {},
                      ),
                      SizedBox(height: Get.height * 0.04),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            details(
                              text1: "#${widget.oID}",
                              text2: "Order Number",
                            ),
                            details(
                                text1: orderData!["service_time"],
                                text2: "Estimate Time"),
                            details(
                              text1:
                                  "${x.homeData!.currency}${orderData!["your_earning"]}",
                              text2: "Earning",
                            ),
                          ]),
                      orderData!["job_start"] != null
                          ? Column(children: [
                              Divider(color: greycolor, thickness: 1.2),
                              SizedBox(height: Get.height * 0.007),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    details(
                                        text1: orderData!["job_start"],
                                        text2: "job Start"),
                                    details(
                                        text1: orderData!["job_end"],
                                        text2: "job End"),
                                  ]),
                              SizedBox(height: Get.height * 0.008),
                            ])
                          : const SizedBox(),

                      Divider(color: Greycolor, thickness: 1.2),
                      orderData!["rider_name"] != ""
                          ? riderDetails()
                          : const SizedBox(),
                      SizedBox(height: Get.height * 0.02),
                      //! ----- Payment summary -----
                      Container(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment summary",
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    fontSize: 15,
                                    color: BlackColor)),
                            SizedBox(height: Get.height * 0.01),
                            priceRow(
                                title: "Item Total:",
                                subtitle:
                                    "${x.homeData!.currency}${orderData!["subtotal"]}",
                                textcolor1: BlackColor,
                                textcolor2: BlackColor,
                                fontSize: 16),
                            orderData!["wall_amt"] != "0"
                                ? Column(children: [
                                    SizedBox(height: Get.height * 0.01),
                                    priceRow(
                                        title: "Wallet:",
                                        subtitle:
                                            "${x.homeData!.currency}${orderData!["wall_amt"]}",
                                        textcolor1: BlackColor,
                                        textcolor2: greentext,
                                        fontSize: 16),
                                  ])
                                : const SizedBox(),
                            orderData!["tip"] != "0"
                                ? Column(
                                    children: [
                                      SizedBox(height: Get.height * 0.01),
                                      priceRow(
                                          title: "Tip:",
                                          subtitle:
                                              "${x.homeData!.currency}${orderData!["tip"]}",
                                          textcolor1: BlackColor,
                                          textcolor2: BlackColor,
                                          fontSize: 16),
                                    ],
                                  )
                                : const SizedBox(),
                            orderData!["cou_amt"] != "0"
                                ? Column(children: [
                                    SizedBox(height: Get.height * 0.01),
                                    priceRow(
                                        title: "Coupon amount:",
                                        subtitle:
                                            "${x.homeData!.currency}${orderData!["cou_amt"]}",
                                        textcolor1: BlackColor,
                                        textcolor2: BlackColor,
                                        fontSize: 16),
                                  ])
                                : const SizedBox(),
                            SizedBox(height: Get.height * 0.01),
                            priceRow(
                                title: "Item discount:",
                                subtitle:
                                    "-${x.homeData!.currency}${orderData!["total_discount"].toStringAsFixed(2)}",
                                textcolor1: BlackColor,
                                textcolor2: greentext,
                                fontSize: 16),
                            SizedBox(height: Get.height * 0.01),
                            priceRow(
                                title: "Convenience fee:",
                                subtitle:
                                    "${x.homeData!.currency}${orderData!["conv_fee"]}",
                                textcolor1: BlackColor,
                                textcolor2: BlackColor,
                                fontSize: 16),
                            SizedBox(height: Get.height * 0.01),
                            priceRow(
                                title: "Tax:",
                                subtitle:
                                    "${x.homeData!.currency}${orderData!["tax"] ?? "0"}",
                                textcolor1: BlackColor,
                                textcolor2: BlackColor,
                                fontSize: 16),
                            Divider(color: Greycolor, thickness: 1.2),
                            SizedBox(height: Get.height * 0.008),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total:",
                                    style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: 'Gilroy Bold',
                                        fontSize: 18)),
                                Text(
                                    "${x.homeData!.currency}${orderData!["total"]}",
                                    style: TextStyle(
                                        color: BlackColor,
                                        fontFamily: 'Gilroy Bold',
                                        fontSize: 18))
                              ],
                            ),
                            SizedBox(height: Get.height * 0.008),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: Get.height * 0.06,
                                width: Get.width * 0.94,
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.local_offer_sharp,
                                        color: Colors.green, size: 32),
                                    const SizedBox(width: 4),
                                    Text(
                                        orderData?["payment_title"] != null
                                            ? "${orderData?["payment_title"] + " " + x.homeData!.currency + orderData?["total"] + " (${orderData?["trans_id"]})"}"
                                            : "",
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Gilroy Medium',
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.04),

                      //! ----- Order Address pickup Drop
                      orderAddress(
                        pickupAddress: orderData!["store_address"],
                        dropAddress: orderData!["customer_address"],
                      )
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.36),
                        isLoadingIndicator(),
                      ],
                    ),
                  )),
      ),
    );
  }

  orderDetailslist(user, i) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: greycolor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 55,
                width: 55,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                        Config.imageURLPath + user[i]["Product_image"],
                        fit: BoxFit.fitHeight))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.001),
                Ink(
                  width: Get.width * 0.56,
                  child: Text(user[i]["Product_name"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Gilroy Bold",
                          fontSize: 15,
                          color: BlackColor)),
                ),
                SizedBox(height: Get.height * 0.008),
                SizedBox(
                  width: Get.width * 0.56,
                  child: Text("Control Service",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Gilroy Medium",
                          fontSize: 14,
                          color: greycolor,
                          overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
            Column(
              children: [
                Text("${user[i]["Product_discount"]}%Off",
                    style: TextStyle(
                        fontFamily: "Gilroy Medium",
                        fontSize: 13,
                        color: greentext)),
                SizedBox(height: Get.height * 0.016),
                Text("${x.homeData!.currency}${user[i]["Product_price"]}",
                    style: TextStyle(
                        fontFamily: "Gilroy Bold",
                        fontSize: 14,
                        color: BlackColor)),
              ],
            )
          ]),
    );
  }

  riderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.015),
        Text("Rider Details",
            style: TextStyle(
                fontFamily: "Gilroy Bold", fontSize: 15, color: BlackColor)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 60,
                width: 60,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                          Config.imageURLPath + orderData!["rider_img"],
                          fit: BoxFit.cover)),
                )),
            SizedBox(width: Get.width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.008),
                Ink(
                    width: Get.width * 0.56,
                    child: Text(orderData!["rider_name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            fontSize: 15,
                            color: BlackColor))),
                SizedBox(height: Get.height * 0.008),
                SizedBox(
                  width: Get.width * 0.56,
                  child: Text(orderData!["rider_mobile"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Gilroy Medium",
                          fontSize: 14,
                          color: Greycolor,
                          overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
          ]),
        ),
        const Divider(thickness: 1, color: Colors.grey)
      ],
    );
  }

  bottomsheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        useRootNavigator: false,
        backgroundColor: WhiteColor,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (BuildContext context) {
          return Container(
            height: Get.height * 0.76,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Get.height / 20),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: Get.width / 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset("assets/Assign.png",
                                    fit: BoxFit.cover,
                                    height: Get.height * 0.40)),
                          ),
                        ),
                      ),
                      Stack(children: [
                        Container(
                          height: Get.height / 1.5, //imagee size
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white,
                                WhiteColor
                              ])),
                        ),
                        Positioned(
                          bottom: 120,
                          left: 75,
                          child: Text(provider.assignSuccess,
                              style: TextStyle(
                                  fontFamily: "Gilroy Bold",
                                  fontSize: 22,
                                  color: BlackColor)),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 32,
                          child: SizedBox(
                            width: Get.width * 0.82,
                            child: Text(provider.congratulation,
                                style: TextStyle(
                                    fontFamily: "Gilroy Medium",
                                    fontSize: 13,
                                    color: greycolor),
                                maxLines: 5),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Button(
                    Width: double.infinity,
                    buttoncolor: gradientColor,
                    buttontext: "go to home",
                    onclick: () {
                      Get.back();
                      Get.back();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Orderbottomsheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Service partner List",
                            style: TextStyle(
                                fontFamily: "Gilroy Bold",
                                color: Greycolor,
                                fontSize: 15)),
                        Appbutton(
                            Width: Get.width * 0.35,
                            border: null,
                            buttoncolor: gradientColor,
                            buttontext: "Add New",
                            onclick: () {
                              Get.to(() => adddeliveryboy(type: "0"))!
                                  .then((value) {
                                setState(() {});
                                x.getDeliveryListApi().then((value) {
                                  items.clear();
                                  partnerlist = value;
                                  value.forEach((e) {
                                    items.add(e["partner_name"]);
                                    print(e["partner_name"]);
                                  });
                                });
                              });
                            },
                            textcolor: WhiteColor)
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),
                    appTextfield(
                        feildcolor: WhiteColor,
                        labelcolor: greycolor,
                        suffix: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                hint: Text('Select Service partner',
                                    style: TextStyle(
                                        fontSize: 14, color: greycolor)),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {});
                                  selectedValue = value as String;
                                  for (var i = 0; i < partnerlist.length; i++) {
                                    if (partnerlist[i]["partner_name"] ==
                                        value) {
                                      riderID = partnerlist[i]["partner_id"];
                                      print(partnerlist[i]["partner_id"]);
                                    }
                                  }
                                },
                                buttonHeight: 40,
                                buttonWidth: double.infinity,
                                itemHeight: 40)),
                        text: "Account"),
                    SizedBox(height: Get.height * 0.02),
                    Center(
                      child: Button(
                          Width: Get.width * 0.7,
                          buttoncolor: gradientColor,
                          buttontext: "Assgian to Service Provider",
                          onclick: assignRiderApi),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  ticketCancell(ticketid) {
    print("ticket ID : $ticketid");
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    const Text(
                      "Select Reason",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Gilroy Bold',
                          color: Color(0xffF0635A)),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Please select the reason for cancellation:",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy Medium',
                          color: BlackColor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: selectradio == "$i"
                                        ? brownColor
                                        : greycolor,
                                    width: 1.5)),
                            child: RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              dense: true,
                              value: i,
                              activeColor: brownColor,
                              tileColor: BlackColor,
                              selected: true,
                              groupValue: selectedRadioTile,
                              title: Text(
                                cancelList[i]["title"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Medium',
                                    color: BlackColor),
                              ),
                              onChanged: (val) {
                                setState(() {});
                                selectradio = "$i";
                                selectedRadioTile = val;
                                rejectmsg = cancelList[i]["title"];
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: Get.height * 0.01),
                    rejectmsg == "Others"
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.94,
                            child: TextField(
                                controller: note,
                                decoration: InputDecoration(
                                    isDense: true,
                                    enabledBorder:
                                        myinputborder(borderColor: BlackColor),
                                    focusedBorder:
                                        myinputborder(borderColor: Colors.grey),
                                    hintText: 'Enter reason',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: Get.height / 55,
                                        color: Colors.grey))),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Cancel",
                            bgColor: redgradient,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Confirm",
                            bgColor: gradientColor,
                            titleColor: Colors.white,
                            ontap: () {
                              cancelOrderApi(ticketid);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          });
        });
  }

  ticketbutton({Function()? ontap, String? title, Color? bgColor, titleColor}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: (BorderRadius.circular(8))),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }

  //! OrderDetails get
  getOrderDetailsApi(String? orderID) {
    setState(() {
      isLoading = true;
    });
    var data = {"order_id": orderID};
    log(data.toString(), name: "order details  : ");
    ApiWrapper.dataPost(Config.orderDetails, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "OrderData : ");
          orderData = val["OrderDetails"];
          switch (orderData!["status"]) {
            case "Accepted":
              oStatus = provider.accept;
              butColor = gradientColor;
              break;
            case "Pending":
              oStatus = provider.pending;
              butColor = orangeColor;
              break;
            case "Ongoing":
              oStatus = provider.ongoing;
              butColor = lightyello;
              break;
            case "Pickup Order":
              oStatus = provider.pickup;
              butColor = gradientColor;
              break;
            case "Pickup Order":
              oStatus = provider.pickupor;
              butColor = RedColor;
              break;
            default:
          }
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

//! OrderDetails get
  cancelOrderApi(String? orderID) {
    var addMsg = rejectmsg == "Other" ? note.text : rejectmsg;
    var data = {"oid": orderID, "status": "0", "comment_reject": addMsg};

    ApiWrapper.dataPost(Config.makedecision, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Reject order: ");
          Get.back();
          Get.back();
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

//! OrderDetails get
  acceptOrderApi(String? orderID) {
    var data = {"oid": orderID, "status": "1", "comment_reject": "0"};

    log(data.toString(), name: "order details  : ");
    print(data.toString());
    ApiWrapper.dataPost(Config.makedecision, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Reject order: ");
          Get.back();

          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

//! ----- assignRider Api -----
  assignRiderApi() {
    var data = {"oid": widget.oID, "rid": riderID};
    log(data.toString(), name: "order details  : ");
    ApiWrapper.dataPost(Config.assRider, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Reject order: ");
          Get.back();
          bottomsheet();
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          isLoading = false;
        } else {
          setState(() {});
          isLoading = false;
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  List cancelList = [
    {"id": 1, "title": "Earnings too low"},
    {"id": 2, "title": "Location too far"},
    {"id": 3, "title": "Store not open"},
    {"id": 4, "title": "Can not find location"},
    {"id": 5, "title": "just want to cancel"},
    {"id": 6, "title": "Others"},
  ];
}
