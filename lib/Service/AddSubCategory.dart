// ignore_for_file: file_names, unused_local_variable, deprecated_member_use, prefer_typing_uninitialized_variables, avoid_print, unused_import, depend_on_referenced_packages, must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:http/http.dart' as http;

class SubCategory extends StatefulWidget {
  Map? service;
  final String? type;

  SubCategory({super.key, this.service, this.type});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  final x = Get.put(HomeGetData());
  final ssc = TextEditingController();
  List<String> seviceStatusList = ["Activate", "Deactivate"];

  String? serviceCat;
  String? serviceStatus;
  var base64Image;
  String catID = "";
  String? recordeID;

  PickedFile? imageFile;
  String? path;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    x.getCatListApi();
    widget.type == "1" ? subUpdate() : null;
  }

  subUpdate() {
    catID = widget.service!["cat_id"];
    recordeID = widget.service!["sub_id"];
    serviceCat = widget.service!["cat_name"];
    ssc.text = widget.service!["sub_title"];
    serviceStatus =
        widget.service!["status"] != "0" ? "Activate" : "Deactivate";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WhiteColor,
      //! Add Sub Category
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: !isLoading
            ? Button(
                buttoncolor: gradientColor,
                buttontext: "Add Sub Category",
                onclick: () {
                  if (ssc.text.isNotEmpty) {
                    addServiceApi();
                  } else {
                    ApiWrapper.showToastMessage(
                        'Please enter Service Sub Category');
                  }
                })
            : isLoadingIndicator(),
      ),
      appBar: CustomAppbar(
          actionicon: null,
          center: true,
          centertext: "Add Sub Category",
          redi: 0,
          onclick: () {}),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.01),
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

            SizedBox(height: Get.height * 0.02),
            //! Service Category Selected
            Container(
              width: Get.width,
              height: Get.height / 15,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Greycolor.withOpacity(0.6), width: 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 3),
                child: DropdownButton(
                  hint: Text('Service Category',
                      style: TextStyle(fontSize: 14, color: greycolor)),
                  underline: const SizedBox(),
                  value: serviceCat,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: x.items.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: SizedBox(
                        width: Get.width * 0.82,
                        child: Text(item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Get.height / 55,
                                fontFamily: 'Gilroy_Medium')),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      serviceCat = value as String;
                      for (var e in x.pickupiteam) {
                        if (e["cat_name"] == value) {
                          catID = e["cat_id"];
                        } else {}
                      }
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: Get.height * 0.02),
            appTextfield(
                controller: ssc,
                feildcolor: WhiteColor,
                labelcolor: greycolor,
                suffix: null,
                text: "Service Sub Category"),
            SizedBox(height: Get.height * 0.02),
            Container(
              width: Get.width,
              height: Get.height / 15,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Greycolor.withOpacity(0.6), width: 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 3),
                child: DropdownButton(
                  hint: Text('Service Status',
                      style: TextStyle(fontSize: 14, color: greycolor)),
                  underline: const SizedBox(),
                  value: serviceStatus,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: seviceStatusList.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: SizedBox(
                        width: Get.width * 0.82,
                        child: Text(item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Get.height / 55,
                                fontFamily: 'Gilroy_Medium')),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      serviceStatus = value as String;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          child: Image.network(Config.imageURLPath + widget.service!["sub_img"],
              width: double.infinity, fit: BoxFit.cover, height: 150)),
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
              Image.asset("assets/Vector.png", height: 70),
              SizedBox(height: Get.height * 0.01),
              Text(
                "Uploade Sub Category Photo",
                style: TextStyle(
                    fontFamily: "Gilroy Medium",
                    color: Greycolor,
                    fontSize: 16),
              )
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
      print(base64Image);
    }
  }

  addServiceApi() {
    setState(() {
      isLoading = true;
    });
    var data = {
      "vendor_id": vendorID,
      "status": serviceStatus == "Activate" ? "1" : "0",
      "cat_id": catID,
      "title": ssc.text,
      "type": widget.type != "1" ? 'Add' : "Update",
      "record_id": widget.type != "1" ? "0" : recordeID,
      "img": base64Image ?? "0"
    };
    log(data.toString(), name: "--Sub Cat Api : ");
    ApiWrapper.dataPost(Config.addSubCategory, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        print(val);
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Sub Cat Api ---------------: ");
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
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
