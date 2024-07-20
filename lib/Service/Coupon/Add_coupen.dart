// ignore_for_file: deprecated_member_use, camel_case_types, file_names, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_declarations, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

class addcoupen extends StatefulWidget {
  final String? type;
  Map? service;
  addcoupen({super.key, this.type, this.service});

  @override
  State<addcoupen> createState() => _addcoupenState();
}

class _addcoupenState extends State<addcoupen> {
  var base64Image;
  String? recordeID;
  List<String> seviceStatusList = ["Activate", "Deactivate"];
  final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
  String? selectedValue;
  String? serviceStatus;
  PickedFile? imageFile;
  String? path;
  String cExpiry = "Coupon Expiry";
  bool isLoading = false;

  final coupontitel = TextEditingController();
  final cCode = TextEditingController();
  final cSubtitle = TextEditingController();
  final mAmount = TextEditingController();
  final cvalue = TextEditingController();
  final desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.type == "1" ? couponUpdate() : null;
  }

  couponUpdate() {
    recordeID = widget.service!["coupon_id"];
    coupontitel.text = widget.service!["title"];
    cSubtitle.text = widget.service!["subtitle"];
    cCode.text = widget.service!["coupon_code"];
    mAmount.text = widget.service!["min_amt"];
    cvalue.text = widget.service!["coupon_val"];
    desc.text = widget.service!["description"];
    cExpiry = widget.service!["expire_date"];

    serviceStatus =
        widget.service!["status"] == "0" ? "Activate" : "Deactivate";
  }

  //{coupon_id: 3, coupon_img: images/coupon/635267228bd02.png, title: salon, coupon_code: welcome 55, subtitle: 10% off,
  // expire_date: 2022-10-25, min_amt: 11, coupon_val: 44, description: txhxhxhxhxhf jfjfjfj. gigjgjv, status: 1}
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: CustomAppbar(
          actionicon: null, centertext: "Add Coupons", redi: 0, center: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! upload image
              widget.type != "1"
                  ? InkWell(
                      onTap: () {
                        openGallery(context);
                      },
                      child: path == null ? defImage() : uploadimage())
                  : InkWell(
                      onTap: () {
                        openGallery(context);
                      },
                      child: path != null ? uploadimage() : networkImage()),
              SizedBox(height: Get.height * 0.025),
              appTextfield(
                  controller: coupontitel,
                  feildcolor: Colors.white,
                  labelcolor: Colors.white,
                  text: "Coupon Title"),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appTextfield(
                      controller: cCode,
                      feildcolor: Colors.white,
                      labelcolor: Colors.grey,
                      Width: Get.width * 0.78,
                      text: "Coupon Code"),
                  InkWell(
                    onTap: () {
                      setState(() {});
                      cCode.text = generatePassword(
                          isNumber: true, isSpecial: false, letter: true);
                    },
                    child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                        child: Image.asset("assets/refresh.png", height: 35)),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  controller: cSubtitle,
                  feildcolor: WhiteColor,
                  labelcolor: greycolor,
                  text: "Coupon Subtitle"),
              SizedBox(height: Get.height * 0.02),
              InkWell(
                onTap: () {
                  selectDate(context);
                },
                child: Container(
                  height: 55,
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: WhiteColor,
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          cExpiry,
                          style: TextStyle(
                              color: cExpiry == "Coupon Expiry"
                                  ? greycolor
                                  : BlackColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // appTextfield(
              //     feildcolor: Colors.white,
              //     labelcolor: Colors.grey,
              //     suffix: DropdownButtonHideUnderline(
              //       child: DropdownButton2(
              //           hint: Text('Coupon Expiry',
              //               style: TextStyle(fontSize: 14, color: greycolor)),
              //           items: items
              //               .map((item) => DropdownMenuItem<String>(
              //                     value: item,
              //                     child: Text(item,
              //                         style: const TextStyle(fontSize: 14)),
              //                   ))
              //               .toList(),
              //           value: selectedValue,
              //           onChanged: (value) {
              //             setState(() {});
              //             selectedValue = value as String;
              //           },
              //           buttonHeight: 40,
              //           buttonWidth: double.infinity,
              //           itemHeight: 40),
              //     ),
              //     text: ""),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appTextfield(
                      controller: mAmount,
                      feildcolor: Colors.white,
                      labelcolor: Colors.grey,
                      keyboardType: TextInputType.number,
                      Width: Get.width * 0.46,
                      text: "Minimum Amount"),
                  appTextfield(
                      controller: cvalue,
                      feildcolor: Colors.white,
                      labelcolor: Colors.grey,
                      keyboardType: TextInputType.number,
                      Width: Get.width * 0.46,
                      text: "Coupon Value"),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: TextField(
                    controller: desc,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "Gilroy Medium",
                            fontSize: 15),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Greycolor.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(15))),
                  )),
              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  feildcolor: Colors.white,
                  labelcolor: Colors.grey,
                  suffix: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      buttonHeight: 40,
                      buttonWidth: double.infinity,
                      itemHeight: 40,
                      hint: Text('Coupon Status',
                          style: TextStyle(fontSize: 14, color: greycolor)),
                      items: seviceStatusList
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14)),
                                ),
                              ))
                          .toList(),
                      value: serviceStatus,
                      onChanged: (value) {
                        setState(() {});
                        serviceStatus = value as String;
                      },
                    ),
                  ),
                  text: "Coupon Status"),
              SizedBox(height: Get.height * 0.06),
              !isLoading
                  ? Button(
                      buttontext: "Add Services",
                      buttoncolor: Colors.green,
                      onclick: () {
                        if (coupontitel.text.isNotEmpty &&
                            cSubtitle.text.isNotEmpty &&
                            mAmount.text.isNotEmpty &&
                            cCode.text.isNotEmpty &&
                            cvalue.text.isNotEmpty &&
                            desc.text.isNotEmpty) {
                          addCouponsApi();
                        } else {
                          ApiWrapper.showToastMessage(
                              "Please fill required field!");
                        }
                        // Get.to(() => const adddeliveryboy());
                      },
                    )
                  : Center(child: Column(children: [isLoadingIndicator()])),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context, //context of current state
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      cExpiry = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {});
      print(cExpiry); //formatted date output using intl package =>  2021-03-16
    } else {
      print("Date is not selected");
    }
  }

  networkImage() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: greycolor),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
              Config.imageURLPath + widget.service!["coupon_img"],
              width: double.infinity,
              fit: BoxFit.cover,
              height: 150)),
    );
  }

  defImage() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Greycolor.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(10)),
      height: 160,
      width: double.infinity,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.025),
              Image.asset("assets/Vector.png", height: 60),
              SizedBox(height: Get.height * 0.01),
              Text("Uploade Photo",
                  style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: Greycolor,
                      fontSize: 16))
            ],
          )),
    );
  }

  uploadimage() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: greycolor),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(File(path.toString()),
              width: double.infinity, fit: BoxFit.cover, height: 150)),
    );
  }

  void openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      setState(() {});
      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      setState(() {});
    }
  }

  addCouponsApi() {
    setState(() {
      isLoading = true;
    });
    var data = {
      "vendor_id": vendorID,
      "status": serviceStatus != "Activate" ? "1" : "0",
      "title": coupontitel.text,
      "expire_date": cExpiry,
      "min_amt": mAmount.text,
      "coupon_val": cvalue.text,
      "type": widget.type != "1" ? 'Add' : "Update",
      "coupon_code": cCode.text,
      "subtitle": cSubtitle.text,
      "record_id": widget.type != "1" ? "0" : recordeID,
      "description": desc.text,
      "img": base64Image ?? "0"
    };
    print(data);
    ApiWrapper.dataPost(Config.couponOperation, data).then((val) {
      print(val);
      if ((val != null) && (val.isNotEmpty)) {
        print(val);
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {
            isLoading = false;
          });
          Get.back();
        } else {
          setState(() {
            isLoading = false;
          });
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
