// ignore_for_file: file_names, must_be_immutable, camel_case_types, deprecated_member_use, unnecessary_string_interpolations, unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

class addcoverimage extends StatefulWidget {
  final String? type;
  final String? recordID;
  final String? cstatus;
  List? cimage;
  final String? catid;
  final String? cname;
  addcoverimage(
      {super.key,
      this.type,
      this.recordID,
      this.cimage,
      this.cname,
      this.cstatus,
      this.catid});

  @override
  State<addcoverimage> createState() => _addcoverimageState();
}

class _addcoverimageState extends State<addcoverimage> {
  final x = Get.put(HomeGetData());

  List<String> seviceStatusList = ["Activate", "Deactivate"];

  String? selectCat;
  String? selectSubCat;
  String? currentDate;
  String? catID;
  String? timeid;
  // List<Asset> resultList = [];
  String? serviceStatus;
  bool isLoading = false;
  List imageList = [];
  String itemId = "0";
  String recordeId = "0";

  @override
  void initState() {
    imageList.clear();
    x.getCatListApi();
    setState(() {});
    widget.type == "1" ? update() : null;
    // }
    super.initState();
  }

  update() {
    setState(() {});
    selectCat = widget.cname;
    catID = widget.catid;
    serviceStatus = widget.cstatus != "0" ? "Activate" : "Deactivate";
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
      x.catWiseGet;
    });
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: !isLoading
              ? Button(
                  buttontext: "Add Cover",
                  buttoncolor: gradientColor,
                  onclick: () {
                    if (widget.type != "1") {
                      imageList.isNotEmpty
                          ? addCoverApi()
                          : ApiWrapper.showToastMessage("please select images");
                    } else {
                      Get.back();
                      addCoverApi();
                    }
                  })
              : isLoadingIndicator(),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("Add Cover Images",
              style: TextStyle(
                  fontSize: 18, color: BlackColor, fontFamily: "Gilroy Bold")),
          leading: Transform.translate(
              offset: const Offset(-6, 0),
              child: BackButton(color: BlackColor)),
          actions: [
            widget.type != "1"
                ? imageList.length <= 4
                    ? InkWell(
                        onTap: () {
                          _openGallery(context, "Add");
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: Get.width * 0.04),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: greycolor.withOpacity(0.4),
                            child: Icon(Icons.add, color: BlackColor),
                          ),
                        ),
                      )
                    : const SizedBox()
                : imageList.length <= 4 && widget.cimage!.length < 5
                    ? InkWell(
                        onTap: () {
                          _openGallery(context, "Add");
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.04),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: greycolor.withOpacity(0.4),
                              child: Icon(Icons.add, color: BlackColor),
                            )))
                    : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.type == "1"
                  ? InkWell(
                      onTap: () {
                        imageList.length <= 4
                            ? _openGallery(context, "")
                            : const SizedBox();
                      },
                      child: imageList.isEmpty
                          ? SizedBox(
                              child: GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children:
                                  List.generate(widget.cimage!.length, (i) {
                                return Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 1)),
                                          width: Get.width * 0.24,
                                          child: Image(
                                              image: NetworkImage(
                                                  Config.imageURLPath +
                                                      widget.cimage![i]
                                                          ["image_url"]),
                                              fit: BoxFit.cover),
                                        )),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                          deleteCoverimageApi(
                                              i, widget.cimage![i]["item_id"]);
                                        },
                                        child: const Image(
                                            image: AssetImage(
                                                "assets/Deleteimage.png"),
                                            height: 24)),
                                  ),
                                  Positioned(
                                      top: -4,
                                      left: 0,
                                      child: InkWell(
                                        onTap: () {
                                          // editImageCoverApi();
                                          setState(() {});
                                          itemId = widget.cimage![i]["item_id"];
                                          _openGallery(context, "Edit");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: lightgrey,
                                              child: const Image(
                                                  image: AssetImage(
                                                      "assets/Edit.png"),
                                                  height: 24)),
                                        ),
                                      ))
                                ]);
                              }),
                            ))
                          :
                          //! image list view
                          imageList.isNotEmpty
                              ? Ink(
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    shrinkWrap: true,
                                    children:
                                        List.generate(imageList.length, (i) {
                                      return Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                height: Get.height * 0.10,
                                                width: Get.width * 0.24,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            File(imageList[i])),
                                                        fit: BoxFit.fill)),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -12,
                                            right: 2,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  imageList
                                                      .remove(imageList[i]);
                                                },
                                                icon: const Image(
                                                    image: AssetImage(
                                                        "assets/Deleteimage.png"),
                                                    height: 24)),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                )
                              : SizedBox(height: Get.height * 0.02),
                    )
                  : InkWell(
                      onTap: () {
                        imageList.length <= 4
                            ? _openGallery(context, "")
                            : const SizedBox();
                        // loadAssets();
                      },
                      child: imageList.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Greycolor.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 160,
                              width: double.infinity,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025),
                                      Image.asset("assets/upload.png",
                                          height: 70),
                                      SizedBox(height: Get.height * 0.01),
                                      Text(
                                        "Uploade Cover Image Max 5",
                                        style: TextStyle(
                                            fontFamily: "Gilroy Medium",
                                            color: greycolor,
                                            fontSize: 16),
                                      )
                                    ],
                                  )),
                            )
                          : Ink(
                              child: GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                children: List.generate(imageList.length, (i) {
                                  return Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          height: Get.height * 0.10,
                                          width: Get.width * 0.24,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      File(imageList[i])),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -12,
                                      right: 2,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {});
                                            imageList.remove(imageList[i]);
                                          },
                                          icon: const Image(
                                              image: AssetImage(
                                                  "assets/Deleteimage.png"),
                                              height: 24)),
                                    ),
                                  ]);
                                }),
                              ),
                            )),
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
                    value: selectCat,
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
                    onChanged: (String? newValue) {
                      setState(() {
                        selectCat = newValue!;
                        for (var e in x.pickupiteam) {
                          if (e["cat_name"] == newValue) {
                            catID = e["cat_id"];
                          }
                        }
                        // selectSubCat = null;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  labelcolor: greycolor,
                  suffix: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                          hint: Text('Service Status',
                              style: TextStyle(fontSize: 14, color: greycolor)),
                          items: seviceStatusList
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: const TextStyle(fontSize: 14)),
                                  ))
                              .toList(),
                          value: serviceStatus,
                          onChanged: (value) {
                            setState(() {
                              serviceStatus = value as String;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: double.infinity,
                          itemHeight: 40)),
                  text: ""),
            ],
          ),
        ));
  }

  addImage() {
    return InkWell(
      onTap: () {},
      child: Container(
          height: 100,
          width: Get.width * 0.20,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10))),
    );
  }

  void _openGallery(BuildContext context, String? edit) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String path = pickedFile.path;
      imageList.add(path);
      if (edit == "Edit") {
        editImageCoverApi();
      } else if (edit == "Add") {
        addCoverApi();
      }
    }
  }

  addCoverApi() {
    setState(() {
      isLoading = true;
    });
    Map<String, String> data = {
      'vendor_id': vendorID,
      'cat_id': catID ?? "",
      'type': "Add",
      'status': serviceStatus == "Activate" ? "1" : "0",
      'record_id': widget.type != "1" ? "0" : widget.recordID.toString(),
      'item_id': itemId,
      'size': imageList.length.toString(),
    };
    log(data.toString());
    for (int i = 0; i < imageList.length; i++) {
      log("${'image$i' "${imageList[i]}"}", name: "Image name :$i");
    }
    ApiWrapper.doImageUpload(Config.coverAddupdate, data, imageList)
        .then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        log(val.toString(), name: "Add Image Api :");

        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          isLoading = false;
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

  editImageCoverApi() {
    setState(() {});
    Map<String, String> data = {
      'vendor_id': vendorID,
      'cat_id': catID ?? "",
      'type': "Update",
      'status': serviceStatus == "Activate" ? "1" : "0",
      'record_id': recordeId,
      'item_id': itemId,
      'size': "1",
    };
    log(data.toString(), name: "Edit Image Api Call :: ");
    for (int i = 0; i < imageList.length; i++) {
      log("${'image$i' "${imageList[i]}"}", name: "Image name :$i");
    }
    ApiWrapper.doImageUpload(Config.coverAddupdate, data, imageList)
        .then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          setState(() {});
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  deleteCoverimageApi(i, itemID) {
    var ilength = imageList.isEmpty ? null : "";
    Map<String, String> data = {
      'vendor_id': vendorID,
      'cat_id': catID ?? "",
      'type': "Delete",
      'status': serviceStatus == "Activate" ? "1" : "0",
      'record_id': recordeId,
      'item_id': itemID,
      'size': imageList.length.toString(),
    };

    ApiWrapper.doImageUpload(Config.coverAddupdate, data, imageList)
        .then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "image Delete : ");
          setState(() {});
          widget.cimage!.removeAt(i);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
