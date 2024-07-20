// ignore_for_file: file_names, unnecessary_string_interpolations

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

final getData = GetStorage();

save(key, val) {
  final data = GetStorage();
  data.write(key, val);
}

isLoadingIndicator() {
  return const CupertinoActivityIndicator(
    animating: true,
    radius: 20,
  );
}

String generatePassword({
  bool letter = true,
  bool isNumber = true,
  bool isSpecial = true,
}) {
  const length = 10;
  const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
  const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const number = '0123456789';
  const special = '@#%^*>\$@?/[]=+';

  String chars = "";
  if (letter) chars += '$letterLowerCase$letterUpperCase';
  if (isNumber) chars += '$number';
  if (isSpecial) chars += '$special';

  return List.generate(length, (index) {
    final indexRandom = Random.secure().nextInt(chars.length);
    return chars[indexRandom];
  }).join('');
}

orderAddress({String? pickupAddress, dropAddress}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Image.asset("assets/metrize.png", height: 28, color: yelloColor),
          SizedBox(width: Get.width * 0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Address",
                  style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: BlackColor,
                      fontSize: 14)),
              SizedBox(
                  width: Get.width * 0.80,
                  child: Text(pickupAddress ?? "",
                      style: TextStyle(
                          fontFamily: "Gilroy Bold",
                          color: BlackColor,
                          fontSize: 14))),
            ],
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 13, bottom: 0, top: 4),
        child: Dash(
            direction: Axis.vertical,
            dashGap: 2,
            length: 25,
            dashThickness: 2,
            dashLength: 5,
            dashColor: greycolor),
      ),
      Row(
        children: [
          Image.asset("assets/Maplocation.png", height: 28, color: brownColor),
          SizedBox(width: Get.width * 0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Customer address",
                  style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: BlackColor,
                      fontSize: 14)),
              SizedBox(
                  width: Get.width * 0.80,
                  child: Text(dropAddress ?? "",
                      style: TextStyle(
                          fontFamily: "Gilroy Bold",
                          color: BlackColor,
                          fontSize: 14))),
            ],
          )
        ],
      ),
    ],
  );
}

orderDetail({String? date, status, Function()? onTap, Color? bColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Details",
              style: TextStyle(
                  fontFamily: "Gilroy Bold", fontSize: 15, color: BlackColor)),
          SizedBox(height: Get.height * 0.012),
          Text(date ?? "",
              style: TextStyle(
                  fontFamily: "Gilroy Medium", fontSize: 14, color: greycolor)),
        ],
      ),
      SizedBox(
        width: Get.width * 0.26,
        height: Get.height * 0.04,
        child: Appbutton(
            Width: Get.width * 0.32,
            border: null,
            buttoncolor: bColor,
            buttontext: status,
            onclick: onTap,
            textcolor: WhiteColor),
      )
    ],
  );
}

details({String? text1, text2}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(text1 ?? "",
          style: TextStyle(
              fontFamily: "Gilroy Bold", fontSize: 15, color: BlackColor)),
      Text(text2,
          style: TextStyle(
              fontFamily: "Gilroy Medium", fontSize: 13, color: greycolor)),
    ],
  );
}

OutlineInputBorder myinputborder({Color? borderColor}) {
  return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: borderColor!, width: 1));
}

priceRow(
    {String? title,
    subtitle,
    Color? textcolor1,
    textcolor2,
    double? fontSize}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!,
            style: TextStyle(
                color: textcolor1,
                fontFamily: 'Gilroy Medium',
                fontSize: fontSize)),
        Text(subtitle!,
            style: TextStyle(
                color: textcolor2,
                fontFamily: 'Gilroy Medium',
                fontSize: fontSize))
      ],
    ),
  );
}
