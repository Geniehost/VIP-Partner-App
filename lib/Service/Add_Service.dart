// ignore_for_file: file_names, deprecated_member_use, unused_local_variable, unused_import, depend_on_referenced_packages, unused_field, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable, unnecessary_string_interpolations, unnecessary_null_in_if_null_operators

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Service/AddSubCategory.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

List<String> image = <String>['Image', 'Videos'];

class Servicedetails extends StatefulWidget {
  Map? service;
  final String? type;
  Servicedetails({super.key, this.type, this.service});

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  final x = Get.put(HomeGetData());
  List<String> seviceStatusList = ["Activate", "Deactivate"];
  final titleService = TextEditingController();
  final serviceTime = TextEditingController();
  final maxQuantity = TextEditingController();
  final price = TextEditingController();
  final discount = TextEditingController();
  final desc = TextEditingController();
  late VideoPlayerController _videoPlayerController;

  var base64Image;
  File? _video;
  String? videopath;
  bool vidioPlay = false;
  bool isloading = false;

  String? serviceCategory;
  String? serviceSubCat;
  String? visibilityShow;
  String? serviceStatus;

  PickedFile? imageFile;
  String? path;
  String? catID;
  String? subID;
  String? recordeID;

  @override
  void initState() {
    super.initState();
    x.getCatListApi();
    x.getSubCatApi();
    widget.type == "1" ? updateData() : null;
  }

  updateData() {
    setState(() {});

    catID = widget.service!["cat_id"];
    x.getCatWiseListApi(catID);

    subID = widget.service!["sub_id"];
    serviceCategory = widget.service!["cat_name"];
    recordeID = widget.service!["service_id"];
    visibilityShow = widget.service!["cat_id"] == "0" ? 'Image' : 'Videos';
    titleService.text = widget.service!["title"];
    serviceTime.text = widget.service!["take_time"];
    maxQuantity.text = widget.service!["max_quantity"];
    price.text = widget.service!["price"];
    discount.text = widget.service!["discount"];
    desc.text = widget.service!["service_desc"];
    serviceStatus =
        widget.service!["status"] == "1" ? "Activate" : "Deactivate";
    videopath = Config.imageURLPath + widget.service!["video"];
    log(videopath.toString(), name: "Video Api Show :: ");

    _videoPlayerController = VideoPlayerController.network(videopath.toString())
      ..initialize().then((_) {
        setState(() {});
        vidioPlay = true;
      });

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(videopath);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
      x.catWiseGet;
    });
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: CustomAppbar(
          actionicon: null, centertext: "Services", redi: 0, center: true),
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
                      child: path == null
                          ? defimage(title: "Uploade Photo")
                          : uploadimage())
                  : InkWell(
                      onTap: () {
                        openGallery(context);
                      },
                      child: path != null ? uploadimage() : networkImage()),

              SizedBox(height: Get.height * 0.02),
              //! ---------- upload Video ----------

              //  widget.type != "1" ?
              // Stack(
              //   children: [
              //     if (_video != null)
              //       _videoPlayerController.value.isInitialized
              //           ? InkWell(
              //               onTap: () {
              //                 pickVideo(context);
              //               },
              //               child: Container(
              //                 height: 160,
              //                 width: double.infinity,
              //                 decoration: BoxDecoration(
              //                     border: Border.all(
              //                         color: Greycolor.withOpacity(0.6)),
              //                     borderRadius: BorderRadius.circular(10)),
              //                 child: AspectRatio(
              //                   aspectRatio:
              //                       _videoPlayerController.value.aspectRatio,
              //                   child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(12),
              //                       child: VideoPlayer(_videoPlayerController)),
              //                 ),
              //               ),
              //             )
              //           : Container()
              //     else
              //       photoupload(
              //           text: "Upload Video",
              //           onclick: () {
              //             pickVideo(context);
              //           }),
              //     _video != null
              //         ? Positioned(
              //             top: Get.height * 0.06,
              //             left: Get.width * 0.40,
              //             child: InkWell(
              //                 onTap: () {
              //                   setState(() {});
              //                   vidioPlay = !vidioPlay;
              //                   if (vidioPlay == true) {
              //                     _videoPlayerController.pause();
              //                   } else {
              //                     _videoPlayerController.play();
              //                   }
              //                 },
              //                 child: Icon(
              //                     vidioPlay ? Icons.play_arrow : Icons.pause,
              //                     color: Colors.white.withOpacity(0.5),
              //                     size: 50)),
              //           )
              //         : const SizedBox()
              //   ],
              // ),
              Stack(
                children: [
                  if (videopath != null)
                    _videoPlayerController.value.isInitialized
                        ? InkWell(
                            onTap: () {
                              pickVideo(context);
                            },
                            child: Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Greycolor.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: AspectRatio(
                                aspectRatio:
                                    _videoPlayerController.value.aspectRatio,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: VideoPlayer(_videoPlayerController)),
                              ),
                            ),
                          )
                        : Container()
                  else
                    photoupload(
                        text: "Upload Video",
                        onclick: () {
                          pickVideo(context);
                        }),
                  videopath != null
                      ? Positioned(
                          top: Get.height * 0.06,
                          left: Get.width * 0.40,
                          child: InkWell(
                              onTap: () {
                                setState(() {});
                                vidioPlay = !vidioPlay;
                                if (vidioPlay == true) {
                                  _videoPlayerController.pause();
                                } else {
                                  _videoPlayerController.play();
                                }
                              },
                              child: Icon(
                                  vidioPlay ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 50)),
                        )
                      : const SizedBox()
                ],
              ),

              SizedBox(height: Get.height * 0.025),

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
                    value: serviceCategory,
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
                    onChanged: (String? value) {
                      setState(() {
                        print("Value : $value");

                        serviceCategory = value!;
                        serviceSubCat = null;

                        for (var e in x.pickupiteam) {
                          if (e["cat_name"] == value) {
                            catID = e["cat_id"];
                          }
                        }

                        setState(() {});
                        x.getCatWiseListApi(catID);
                        print("catID === >> : $catID");
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //! sub Category
                  Container(
                    width: Get.width * 0.78,
                    height: Get.height / 15,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Greycolor.withOpacity(0.6), width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 3),
                      child: DropdownButton(
                        hint: Text(
                            widget.type != "1"
                                ? 'Service Sub Category'
                                : widget.service!["subcat_name"],
                            style: TextStyle(
                                fontSize: 14,
                                color: widget.type != "1"
                                    ? greycolor
                                    : BlackColor)),
                        underline: const SizedBox(),
                        value: serviceSubCat,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: x.catWiseGet.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: SizedBox(
                              width: Get.width * 0.68,
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
                            print("newValue : $newValue");
                            serviceSubCat = newValue;
                            for (var e in x.catWiseGetID) {
                              if (e["sub_title"] == newValue) {
                                subID = e["sub_id"];
                                print(subID);
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Get.to(() => SubCategory())!.then((value) {
                        setState(() {});
                        x.getCatListApi();
                      });
                    },
                    child: CircleAvatar(
                        radius: 24,
                        backgroundColor: greycolor.withOpacity(0.4),
                        child: Icon(Icons.add, color: BlackColor, size: 35)),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  feildcolor: WhiteColor,
                  labelcolor: greycolor,
                  suffix: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                        hint: Text('Visibility Show to image/video',
                            style: TextStyle(fontSize: 14, color: greycolor)),
                        items: image
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        value: visibilityShow,
                        onChanged: (value) {
                          setState(() {
                            visibilityShow = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: double.infinity,
                        itemHeight: 40),
                  ),
                  text: ""),
              SizedBox(height: Get.height * 0.02),
              appTextfield(
                  controller: titleService,
                  feildcolor: WhiteColor,
                  labelcolor: greycolor,
                  suffix: null,
                  text: "Service Title"),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appTextfield(
                      Width: Get.width * 0.46,
                      controller: serviceTime,
                      feildcolor: WhiteColor,
                      labelcolor: greycolor,
                      keyboardType: TextInputType.number,
                      suffix: null,
                      text: "Service Time"),
                  appTextfield(
                      Width: Get.width * 0.46,
                      controller: maxQuantity,
                      feildcolor: WhiteColor,
                      labelcolor: greycolor,
                      keyboardType: TextInputType.number,
                      suffix: null,
                      text: "Max Quantity"),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appTextfield(
                      Width: Get.width * 0.46,
                      controller: price,
                      labelcolor: greycolor,
                      keyboardType: TextInputType.number,
                      suffix: null,
                      text: "Price"),
                  appTextfield(
                      Width: Get.width * 0.46,
                      controller: discount,
                      labelcolor: greycolor,
                      keyboardType: TextInputType.number,
                      suffix: null,
                      text: "Discount"),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: WhiteColor),
                  child: TextField(
                    controller: desc,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(
                          color: greycolor,
                          fontFamily: "Gilroy Medium",
                          fontSize: 15),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Greycolor.withOpacity(0.6)),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  )),
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
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 14),
                                  ),
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
                        itemHeight: 40),
                  ),
                  text: ""),
              SizedBox(height: Get.height * 0.06),
              !isloading
                  ? Button(
                      buttontext: "Add Services",
                      buttoncolor: gradientColor,
                      onclick: () {
                        // if (widget.type == "1") {
                        //   addServiceApi();
                        // }
                        var data = {
                          'vendor_id': vendorID,
                          'cat_id': catID ?? "",
                          'sub_id': subID ?? "",
                          'service_type': visibilityShow == 'Image' ? "0" : "1",
                          'title': titleService.text,
                          'take_time': serviceTime.text,
                          'record_id': widget.type != "1" ? '0' : "1",
                          'type': widget.type != "1" ? 'Add' : "Update",
                          'max_quantity': maxQuantity.text,
                          'price': price.text,
                          'discount': discount.text,
                          'service_desc': desc.text,
                          'status': serviceStatus == "Activate" ? "1" : "0"
                        };
                        log(data.toString(), name: "Api Call : ");
                        if (serviceTime.text.isNotEmpty &&
                            maxQuantity.text.isNotEmpty &&
                            price.text.isNotEmpty &&
                            discount.text.isNotEmpty &&
                            desc.text.isNotEmpty) {
                          addServiceApi();
                        } else {
                          ApiWrapper.showToastMessage(
                              "Please fill required field!");
                        }
                      },
                    )
                  : Center(child: Column(children: [isLoadingIndicator()])),
              SizedBox(height: Get.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  photoupload({text, Function()? onclick}) {
    return InkWell(
      onTap: onclick,
      child: Container(
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
                  text,
                  style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: greycolor,
                      fontSize: 16),
                )
              ],
            )),
      ),
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

  networkImage() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: greycolor),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(Config.imageURLPath + widget.service!["img"],
              width: double.infinity, fit: BoxFit.cover, height: 150)),
    );
  }

  defimage({String? title}) {
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
              Text(title ?? "",
                  style: TextStyle(
                      fontFamily: "Gilroy Medium",
                      color: greycolor,
                      fontSize: 16))
            ],
          )),
    );
  }

  openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      setState(() {});
      File imageFile = File(path.toString());
    }
  }

  //! video Upload

  final picker = ImagePicker();
  pickVideo(BuildContext context) async {
    final video = await picker.pickVideo(source: ImageSource.gallery);
    _video = File(video!.path);
    videopath = video.path;
    _videoPlayerController = VideoPlayerController.file(File(video.path))
      ..initialize().then((_) {
        setState(() {});
        // _videoPlayerController.play();
      });
    setState(() {});
  }

  addServiceApi() async {
    setState(() {
      isloading = true;
    });

    var data = {
      'vendor_id': vendorID,
      'cat_id': catID ?? "",
      'sub_id': subID ?? "",
      'service_type': visibilityShow == 'Image' ? "0" : "1",
      'title': titleService.text,
      'take_time': serviceTime.text,
      'record_id': widget.type != "1" ? '0' : recordeID,
      'type': widget.type != "1" ? 'Add' : "Update",
      'max_quantity': maxQuantity.text,
      'price': price.text,
      'discount': discount.text,
      'service_desc': desc.text,
      'status': serviceStatus == "Activate" ? "1" : "0",
      path ?? 'image': "0",
      videopath ?? 'video': "0",
    };
    log(data.toString(), name: "Service Add :: ");
    var headers = {'Cookie': 'PHPSESSID=8li0dk9vn50up7hetehf3ir7lg'};
    var request = http.MultipartRequest(
        'POST', Uri.parse(Config.baseurl + Config.serviceAddUpdate));
    request.fields.addAll({
      'vendor_id': vendorID,
      'cat_id': catID ?? "",
      'sub_id': subID ?? "",
      'service_type': visibilityShow == 'Image' ? "0" : "1",
      'title': titleService.text,
      'take_time': serviceTime.text,
      'record_id': widget.type != "1" ? '0' : recordeID.toString(),
      'type': widget.type != "1" ? 'Add' : "Update",
      'max_quantity': maxQuantity.text,
      'price': price.text,
      'discount': discount.text,
      'service_desc': desc.text,
      'status': serviceStatus == "Activate" ? "1" : "0",
      path ?? 'image': "0",
      videopath ?? 'video': "0",
    });
    path != null
        ? request.files
            .add(await http.MultipartFile.fromPath('image', path ?? '0'))
        : null;
    videopath != null
        ? request.files
            .add(await http.MultipartFile.fromPath('video', videopath ?? '0'))
        : null;

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var model = jsonStringToMap(await response.stream.bytesToString());
      if (model["ResponseCode"] == "200") {
        x.getServiceApi();
        setState(() {
          isloading = false;
        });
        Get.back();
        ApiWrapper.showToastMessage(model["ResponseMsg"]);
      } else {
        setState(() {
          isloading = false;
        });
        Get.back();

        ApiWrapper.showToastMessage(model["ResponseMsg"]);
      }
    } else {
      setState(() {
        isloading = false;
      });
    }
  }

  jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }
}
