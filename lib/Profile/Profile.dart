// ignore_for_file: depend_on_referenced_packages, file_names, avoid_print, deprecated_member_use, sort_child_properties_last, prefer_adjacent_string_concatenation, unused_catch_clause, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Booking/Booking.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/login&signup/Login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'FaqPage.dart';
import 'loream.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final pname = TextEditingController();
  final stime = TextEditingController();
  final lCode = TextEditingController();
  final sCharge = TextEditingController();
  final password = TextEditingController();
  final sDesc = TextEditingController();
  bool showpassword = false;
  String? path;
  // var userdata;
  String? networkimage;
  String? base64Image;
  final ImagePicker imgpicker = ImagePicker();
  PickedFile? imageFile;
  bool isdark = false;
  String? text;
  List<DynamicPageData> dynamicPageDataList = [];
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getWebData();
    getPackage();
    getData.read("UserLogin") != null
        ? setState(() {
            pname.text = getData.read("UserLogin")["title"] ?? "";
            stime.text = getData.read("UserLogin")["dtime"] ?? "";
            lCode.text = getData.read("UserLogin")["lcode"] ?? "";
            sCharge.text = getData.read("UserLogin")["store_charge"] ?? "";
            password.text = getData.read("UserLogin")["password"] ?? "";
            sDesc.text = getData.read("UserLogin")["sdesc"] ?? "";
            networkimage = getData.read("UserLogin")["rimg"] ?? "";
          })
        : null;
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  void getWebData() {
    Map<String, dynamic> data = {};

    dynamicPageDataList.clear();
    ApiWrapper.dataPost(Config.pagelist, data).then((value) {
      if ((value != null) &&
          (value.isNotEmpty) &&
          (value['ResponseCode'] == "200")) {
        List da = value['pagelist'];
        for (int i = 0; i < da.length; i++) {
          Map<String, dynamic> mapData = da[i];
          DynamicPageData a = DynamicPageData.fromJson(mapData);
          dynamicPageDataList.add(a);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.06),
              Column(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          _openGallery(context);
                        },
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            height: Get.height * 0.12,
                            width: Get.width * 0.28,
                            child: path == null
                                ? networkimage != ""
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: FadeInImage.assetNetwork(
                                            height: 52,
                                            width: 52,
                                            fadeInCurve: Curves.easeInCirc,
                                            placeholder: "assets/skeleton.gif",
                                            fit: BoxFit.cover,
                                            image: Config.imageURLPath +
                                                networkimage!,
                                            placeholderFit: BoxFit.cover),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: Get.height / 18,
                                        child: Image.asset("assets/user1.png",
                                            fit: BoxFit.cover))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(File(path.toString()),
                                        fit: BoxFit.cover),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -4,
                          right: 105,
                          child: InkWell(
                            onTap: () {
                              _openGallery(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: lightgrey,
                                  child: Icon(Icons.edit,
                                      color: BlackColor, size: 18)),
                            ),
                          ))
                    ],
                  ),
                  Text(pname.text,
                      style: const TextStyle(
                          fontSize: 16, fontFamily: "Gilroy Bold")),
                  SizedBox(height: Get.height * 0.004),
                  Text(getData.read("UserLogin")["email"] ?? "",
                      style: const TextStyle(
                          fontSize: 16, fontFamily: "Gilroy Medium")),
                  SizedBox(height: Get.height * 0.008),
                  InkWell(
                    onTap: editProfile,
                    child: Container(
                      height: 35,
                      width: Get.width * 0.40,
                      decoration: BoxDecoration(
                          border: Border.all(color: blueColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text("Edit profile",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Gilroy Bold",
                                  color: blueColor))),
                    ),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.018),
              const Text("Profile",
                  style: TextStyle(fontSize: 18, fontFamily: "Gilroy Bold")),
              SizedBox(height: Get.height * 0.018),
              // profilemenu(
              //   icon: Icons.keyboard_arrow_right_rounded,
              //   image: "assets/partnership.png",
              //   text: "Register as a Partner",
              //   onTap: () {},
              // ),
              profilemenu(
                  icon: Icons.keyboard_arrow_right_rounded,
                  text: "My Booking",
                  image: "assets/calendar.png",
                  onTap: () {
                    Get.to(() => const Booking(), duration: Duration.zero);
                  }),
              profilemenu(
                  icon: Icons.keyboard_arrow_right_rounded,
                  image: "assets/Star1.png",
                  text: "Rate us",
                  onTap: share),
              profilemenu(
                  icon: Icons.keyboard_arrow_right_rounded,
                  image: "assets/Info Square.png",
                  text: "FAQ's",
                  onTap: () {
                    Get.to(() => const Faq());
                  }),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: dynamicPageDataList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return profilemenu(
                      icon: Icons.keyboard_arrow_right_rounded,
                      image: "assets/Shield Done.png",
                      text: dynamicPageDataList[i].title,
                      onTap: () {
                        Get.to(() => Loream(
                            title: dynamicPageDataList[i].title,
                            description: dynamicPageDataList[i].description));
                      });
                },
              ),
              // profilemenu(
              //     image: "assets/Show.png",
              //     text: "Dark Mode",
              //     darkmode: Transform.scale(
              //       scale: 0.7,
              //       child: CupertinoSwitch(
              //         activeColor: Darkblue,
              //         value: isdark,
              //         onChanged: (val) async {
              //           // final prefs = await SharedPreferences.getInstance();
              //           setState(() {
              //             isdark = val;
              //             // prefs.setBool("setIsDark", val);
              //           });
              //         },
              //       ),
              //     ),
              //     onTap: () {}),
              profilemenu(
                  icon: Icons.keyboard_arrow_right_rounded,
                  image: "assets/Delete.png",
                  text: "Delete Account",
                  onTap: () {
                    DeletShowModalBottomSheet();
                  }),
              profilemenu(
                  icon: Icons.keyboard_arrow_right_rounded,
                  image: "assets/logout.png",
                  text: "Logout",
                  onTap: () {
                    save("Remember", false);
                    getData.remove("FirstUser");
                    Get.offAll(() => const LoginScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  DeletShowModalBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: WhiteColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        )),
        builder: (context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text("Delete Account".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BlackColor,
                          fontFamily: "Gilroy Bold",
                          fontSize: 20)),
                  const SizedBox(height: 14),
                  Text("Are you sure You want to delete the account".tr,
                      style: TextStyle(
                          color: BlackColor,
                          fontFamily: "Gilroy Bold",
                          fontSize: 14)),
                  const Expanded(child: SizedBox(height: 14)),
                  DeleteAccountButton(),
                  const SizedBox(height: 10),
                  cancelButton(),
                ]),
          );
        });
  }

  Widget cancelButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: greycolor),
        child: Center(
          child: Text("Cancel".tr,
              style: TextStyle(
                  color: WhiteColor,
                  fontFamily: "Gilroy Bold",
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget DeleteAccountButton() {
    return GestureDetector(
      onTap: () {
        accountDelete();
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: blueColor),
        child: Center(
          child: Text("Yes,Delete".tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Gilroy Bold",
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  profilemenu(
      {String? text,
      image,
      IconData? icon,
      Function()? onTap,
      Widget? darkmode}) {
    return Column(
      children: [
        Container(
          height: Get.height / 16,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Row(
                  children: [
                    SizedBox(width: Get.width / 80),
                    Container(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(image),
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    Text(text!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Gilroy Bold",
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                const Spacer(),
                darkmode ?? Icon(icon, size: 25),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.008),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  editProfile() {
    return showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: Get.height * 0.60,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.014),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text("Edit profile",
                                style: TextStyle(
                                    fontFamily: "Gilroy Bold",
                                    fontSize: 16,
                                    color: BlackColor)),
                          ),

                          SizedBox(height: Get.height * 0.014),

                          // Text("Service Provider Name",
                          //     style: TextStyle(
                          //         fontFamily: "Gilroy Bold",
                          //         fontSize: 16,
                          //         color: BlackColor)),

                          SizedBox(height: Get.height * 0.01),
                          appTextfield(
                              controller: pname,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              suffix: null,
                              text: "Service Provider Name"),
                          SizedBox(height: Get.height * 0.014),

                          appTextfield(
                              controller: stime,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              suffix: null,
                              keyboardType: TextInputType.number,
                              text: "Approx Service Time"),
                          SizedBox(height: Get.height * 0.014),

                          appTextfield(
                              controller: lCode,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              suffix: null,
                              text: "Certificate/License Code"),

                          SizedBox(height: Get.height * 0.014),

                          appTextfield(
                              controller: sCharge,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              suffix: null,
                              text: "Store Charge"),
                          SizedBox(height: Get.height * 0.014),

                          appTextfield(
                              controller: password,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              readOnly: true,
                              suffix: null,
                              text: "Password"),
                          SizedBox(height: Get.height * 0.014),

                          appTextfield(
                              controller: sDesc,
                              feildcolor: WhiteColor,
                              labelcolor: greycolor,
                              suffix: null,
                              text: "Short Description"),
                          SizedBox(height: Get.height * 0.014),

                          Button(
                            Width: double.infinity,
                            buttoncolor: gradientColor,
                            buttontext: "Save Change",
                            onclick: () {
                              saveProfile();
                            },
                          )
                        ],
                      ),
                    )),
              ),
            );
          });
        });
  }

  //! network base64Image
  networkimageconvert() {
    (() async {
      http.Response response = await http
          .get(Uri.parse(Config.imageURLPath + networkimage.toString()));
      if (mounted) {
        print(response.bodyBytes);
        setState(() {
          base64Image = const Base64Encoder().convert(response.bodyBytes);
          // _bytesImage = Base64Decoder().convert(_imgString);
          print(base64Image);
        });
      }
    })();
  }

  void _openGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      path = pickedFile.path;
      setState(() {});
      File imageFile = File(path.toString());
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      log(base64Image.toString());
      imageupload(base64Image);
    }
  }

  imageupload(String? base64image) async {
    var pid = vendorID;
    var request =
        http.Request('POST', Uri.parse(Config.baseurl + Config.imageUpdate));
    request.body = '''{"pid": "$pid", "img": "$base64image"}''';
    request.headers.addAll(ApiWrapper.headers);
    http.StreamedResponse response = await request.send();
    final Map<String, dynamic> parsed =
        json.decode(await response.stream.bytesToString());

    if (parsed['ResponseCode'] == "200") {
      print(parsed);
      save("UserLogin", parsed["storedata"]);
      ApiWrapper.showToastMessage(parsed["ResponseMsg"]);
    } else {
      ApiWrapper.showToastMessage(parsed["ResponseMsg"]);
    }
  }

  saveProfile() {
    var body = {
      "pid": vendorID,
      "title": pname.text.toString(),
      "dtime": stime.text,
      "lcode": lCode.text.toString(),
      "store_charge": sCharge.text.toString(),
      "password": password.text.toString(),
      "sdesc": sDesc.text.toString(),
    };

    log(body.toString(), name: "Save Update ======== >>>>> ");
    ApiWrapper.dataPost(Config.profileUpdate, body).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          // save("UserLogin", val["storedata"].toString());
          save("UserLogin", val["storedata"]);
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  dialogShow({required String title}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              content: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              actions: <Widget>[
                TextButton(
                    child: const Text("Delete",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                    onPressed: accountDelete),
                TextButton(
                  child: const Text("No",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                  onPressed: () {
                    Get.back();
                  },
                )
              ]);
        });
  }

  Future<void> share() async {
    try {
      launch("market://details?id=" + "$packageName");
    } on PlatformException catch (e) {
      launch("https://play.google.com/store/apps/details?id=$packageName");
    } finally {
      launch("https://play.google.com/store/apps/details?id=$packageName");
    }
  }

  //! Account Delete User
  accountDelete() {
    var data = {"uid": ""};
    ApiWrapper.dataPost(Config.deleteAc, data).then((accDelete) {
      log(accDelete.toString(), name: "Delete Data Api user :: ");
      if ((accDelete != null) && (accDelete.isNotEmpty)) {
        if ((accDelete['ResponseCode'] == "200") &&
            (accDelete['Result'] == "true")) {
          log(accDelete.toString(), name: "Account Delete :: ");
          getData.remove("UserData");
          Get.offAll(() => const LoginScreen());
          ApiWrapper.showToastMessage(accDelete["ResponseMsg"]);
        }
      }
    });
  }
}
