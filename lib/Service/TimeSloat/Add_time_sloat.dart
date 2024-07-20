// ignore_for_file: unused_import, file_names, sized_box_for_whitespace, avoid_print, prefer_const_constructors, must_be_immutable, unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Service/AddSubCategory.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import '../../Utils/AppWidget.dart';

class Addtimesloat extends StatefulWidget {
  Map? timesloat;
  final String? type;
  Addtimesloat({super.key, this.type, this.timesloat});
  @override
  State<Addtimesloat> createState() => _AddtimesloatState();
}

class _AddtimesloatState extends State<Addtimesloat> {
  final x = Get.put(HomeGetData());

  final List<String> items = ['Current', 'Next'];
  String? selectCat;
  String? selectSubCat;
  String? currentDate;
  // String? selectedValue;
  String? catID;
  String? subID;
  String? timeid;
  final day = TextEditingController();

  var selectSell = [];

  @override
  void initState() {
    x.getCatListApi();
    x.getSubCatApi();
    widget.type == "1" ? updatetime() : null;

    super.initState();
  }

  updatetime() {
    setState(() {});
    selectSell.clear();
    catID = widget.timesloat!["cat_id"];
    x.getCatWiseListApi(catID);
    subID = widget.timesloat!["sub_id"];
    selectCat = widget.timesloat!["cat_name"];
    day.text = widget.timesloat!["total_days"];
    timeid = widget.timesloat!["time_id"];
    currentDate = widget.timesloat!["day_type"] == "0" ? "Current" : "Next";
    var timeSloat = (widget.timesloat!["timeslot"].split(','));
    for (var i = 0; i < timeSloat.length; i++) {
      var indx = timeSloat[i];
      if (!selectSell.contains(indx)) {
        print("------1 indx : ${indx}");
        setState(() {});
        selectSell.add(indx);
      } else {
        setState(() {});
        selectSell.remove(indx);
      }
    }
    setState(() {});
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
        bottomNavigationBar: !isloading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Button(
                  buttontext: 'Update',
                  buttoncolor: gradientColor,
                  onclick: addTimeSloatApi,
                ),
              )
            : isLoadingIndicator(),
        appBar: CustomAppbar(
          redi: 0,
          center: true,
          centertext: "Add Time Sloat",
          onclick: () {},
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    //! Service Category Selected
                    Container(
                      width: Get.width,
                      height: Get.height / 15,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Greycolor.withOpacity(0.6), width: 1),
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
                                setState(() {});
                                selectSubCat = null;
                                x.getCatWiseListApi(catID);
                              }
                            });
                          },
                        ),
                      ),
                    ),

                    // SizedBox(height: Get.height * 0.02),
                    // //! sub Category
                    // Container(
                    //   width: Get.width,
                    //   height: Get.height / 15,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           color: Greycolor.withOpacity(0.6), width: 1),
                    //       borderRadius: BorderRadius.circular(12)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 8, top: 3),
                    //     child: DropdownButton(
                    //       hint: Text(
                    //           widget.type != "1"
                    //               ? 'Service Sub Category'
                    //               : widget.timesloat!["subcat_name"],
                    //           style: TextStyle(
                    //               fontSize: 14,
                    //               color: widget.type != "1"
                    //                   ? greycolor
                    //                   : BlackColor)),
                    //       underline: const SizedBox(),
                    //       value: selectSubCat,
                    //       icon: const Icon(Icons.arrow_drop_down),
                    //       items: x.catWiseGet.map((String item) {
                    //         return DropdownMenuItem<String>(
                    //           value: item,
                    //           child: SizedBox(
                    //             width: Get.width * 0.82,
                    //             child: Text(item,
                    //                 maxLines: 1,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 style: TextStyle(
                    //                     fontSize: Get.height / 55,
                    //                     fontFamily: 'Gilroy_Medium')),
                    //           ),
                    //         );
                    //       }).toList(),
                    //       onChanged: (String? newValue) {
                    //         setState(() {
                    //           selectSubCat = newValue;
                    //           for (var e in x.catWiseGetID) {
                    //             if (e["sub_title"] == newValue) {
                    //               subID = e["sub_id"];
                    //               print(subID);
                    //             } else {}
                    //           }
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: Get.height * 0.02),
                    appTextfield(
                        feildcolor: Colors.white,
                        labelcolor: Colors.grey,
                        suffix: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              hint: Text('Current or Next Date',
                                  style: TextStyle(
                                      fontSize: 14, color: greycolor)),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Text(item,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        ),
                                      ))
                                  .toList(),
                              value: currentDate,
                              onChanged: (value) {
                                setState(() {
                                  currentDate = value as String;
                                });
                              },
                              buttonHeight: 40,
                              buttonWidth: double.infinity,
                              itemHeight: 40),
                        ),
                        text: ""),
                    SizedBox(height: Get.height * 0.02),
                    appTextfield(
                        controller: day,
                        feildcolor: Colors.white,
                        labelcolor: Colors.grey,
                        suffix: null,
                        keyboardType: TextInputType.number,
                        text: "Date + Day"),
                    SizedBox(height: Get.height * 0.02),
                    Container(
                      width: Get.width * 0.96,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 6,
                        children: [
                          ...List.generate(
                            Addtime.length,
                            (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    // selectedIndex = service;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: multitimesloat(index,
                                      allColor: selectSell
                                              .contains(Addtime[index]["text"])
                                          ? Colors.blue
                                          : greycolor,
                                      bordercolor: selectSell
                                              .contains(Addtime[index]["text"])
                                          ? Colors.blue.shade50
                                          : Colors.transparent, onclick: () {
                                    if (!selectSell
                                        .contains(Addtime[index]["text"])) {
                                      setState(() {});
                                      selectSell.add(Addtime[index]["text"]);
                                    } else {
                                      setState(() {});
                                      selectSell.remove(Addtime[index]["text"]);
                                    }
                                  }, text: Addtime[index]["text"].toString()),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  multitimesloat(i,
      {Function()? onclick, Color? allColor, bordercolor, String? text}) {
    return GestureDetector(
      onTap: onclick,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Container(
              margin: EdgeInsets.zero,
              width: Get.width * 0.27,
              decoration: BoxDecoration(
                  border: Border.all(color: allColor!, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: bordercolor),
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 8,
                  ),
                  child: Center(
                    child: Text(
                      text!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )),
            ),
          ),
          Positioned(
            right: 0,
            child: selectSell.contains(Addtime[i]["text"])
                ? CircleAvatar(
                    radius: 11,
                    backgroundColor: Darkblue,
                    child:
                        Icon(Icons.check, color: Colors.white, size: 15), //Txt
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  addTimeSloatApi() {
    setState(() {
      isloading = true;
    });
    var data = {
      "vendor_id": vendorID,
      "sub_id": subID,
      "cat_id": catID,
      "timeslot": selectSell.join(","),
      "type": widget.type == "0" ? "Add" : "Update",
      "day_type": currentDate == "Current" ? "0" : "1",
      "total_days": day.text,
      "record_id": widget.type == "0" ? "0" : timeid,
    };

    ApiWrapper.dataPost(Config.timeSloat, data).then((val) {
      print(val);
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {
            isloading = false;
          });
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          // log(val.toString(), name: "Home Data Api : ");
        } else {
          setState(() {
            isloading = false;
          });
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
