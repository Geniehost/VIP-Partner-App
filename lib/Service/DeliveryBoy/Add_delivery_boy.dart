// ignore_for_file: camel_case_types, deprecated_member_use, file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import '../../Utils/AppWidget.dart';

class adddeliveryboy extends StatefulWidget {
  final String? type;
  Map? dBoy;
  adddeliveryboy({super.key, this.type, this.dBoy});

  @override
  State<adddeliveryboy> createState() => _adddeliveryboyState();
}

class _adddeliveryboyState extends State<adddeliveryboy> {
  List<String> seviceStatusList = ["Activate", "Deactivate"];

  PickedFile? imageFile;
  String? recordeID;
  String? path;
  List<String> items = [];
  var base64Image;
  bool _obscureText = true;
  String? serviceStatus;
  String? cCodeList;
  final fName = TextEditingController();
  final email = TextEditingController();
  final cCode = TextEditingController();
  final number = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  bool isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    countryCodeApi();
    super.initState();
    widget.type == "1" ? updateDBoy() : null;
  }

  updateDBoy() {
    setState(() {});
    recordeID = widget.dBoy!["partner_id"];
    fName.text = widget.dBoy!["partner_name"];
    email.text = widget.dBoy!["email"];
    number.text = widget.dBoy!["mobile"];
    password.text = widget.dBoy!["password"];
    address.text = widget.dBoy!["partner_name"];
    cCodeList = widget.dBoy!["ccode"];
    serviceStatus = widget.dBoy!["status"] != "0" ? "Activate" : "Deactivate";
  }

// {partner_id: 1, partner_name: Sandip, email: test@gmail.com, ccode: +91, mobile: 9284798223, password: 1234, status: 1}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        actionicon: null,
        centertext: "Add Service partner",
        redi: 0,
        center: true,
      ),
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
                  controller: fName,
                  feildcolor: Colors.white,
                  labelcolor: Colors.white,
                  text: "Full Name"),
              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  controller: email,
                  feildcolor: Colors.white,
                  labelcolor: Colors.grey,
                  text: "Email Address"),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width * 0.25,
                    height: Get.height / 15,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Greycolor.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 3),
                      child: DropdownButton(
                        // hint: Text('Code',
                        //     style: TextStyle(fontSize: 14, color: greycolor)),
                        underline: const SizedBox(),
                        value: cCodeList,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: items.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: SizedBox(
                              width: Get.width * 0.14,
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
                            cCodeList = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                  appTextfield(
                      controller: number,
                      feildcolor: Colors.white,
                      labelcolor: Colors.grey,
                      keyboardType: TextInputType.number,
                      Width: Get.width / 1.5,
                      text: "Mobile Number"),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              passwordtextfield(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: TextField(
                  controller: address,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Address",
                    labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "Gilroy Medium",
                        fontSize: 15),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Greycolor.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
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
              SizedBox(height: Get.height * 0.05),
              !isLoading
                  ? Button(
                      buttontext: "Add Services",
                      buttoncolor: Colors.green,
                      onclick: () {
                        if (fName.text.isNotEmpty &&
                            email.text.isNotEmpty &&
                            number.text.isNotEmpty &&
                            password.text.isNotEmpty &&
                            address.text.isNotEmpty) {
                          addDBoyApi();
                        } else {
                          ApiWrapper.showToastMessage(
                              "Please fill required field!");
                        }
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

  Widget passwordtextfield() {
    return Container(
      height: Get.height / 10,
      width: double.infinity,
      color: Colors.transparent,
      child: TextField(
        controller: password,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16, color: BlackColor),
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
            child: InkWell(
                onTap: () {
                  _toggle();
                },
                child: _obscureText
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.grey)),
          ),
          labelText: "password",
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Greycolor.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(10)),
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
          child: Image.network(Config.imageURLPath + widget.dBoy!["img"],
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
    }
  }

  addDBoyApi() {
    setState(() {
      isLoading = true;
    });
    var data = {
      "vendor_id": vendorID,
      "status": serviceStatus == "Activate" ? "1" : "0",
      "title": fName.text,
      "email": email.text,
      "type": widget.type != "1" ? 'Add' : "Update",
      "ccode": cCodeList.toString(),
      "mobile": number.text,
      "record_id": widget.type != "1" ? "0" : recordeID,
      "password": password.text,
      "img": base64Image ?? "0"
    };
    log(data.toString(), name: "--Sub Cat Api : ");
    ApiWrapper.dataPost(Config.partnerOperation, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "Sub Cat Api : ");
          setState(() {});
          isLoading = false;

          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          setState(() {
            isLoading = false;
          });
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  countryCodeApi() {
    ApiWrapper.dataGet(Config.cCode)!.then((ccode) {
      if ((ccode != null) && (ccode.isNotEmpty)) {
        if ((ccode['ResponseCode'] == "200") && (ccode['Result'] == "true")) {
          ccode["CountryCode"].forEach((e) {
            setState(() {});
            items.add(e["ccode"]);
          });
          cCodeList = items.first;
        }
      }
    });
  }
}
