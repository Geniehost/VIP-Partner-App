// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:service_provider/Utils/Colors.dart';

Appbutton(
    {String? buttontext,
    double? Width,
    Function()? onclick,
    Color? textcolor,
    buttoncolor,
    Border? border}) {
  return InkWell(
    onTap: onclick,
    child: Container(
      height: 40,
      width: Width,
      decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(50),
          color: buttoncolor),
      child: Center(
        child: Text(buttontext!,
            style: TextStyle(
                fontFamily: "Gilroy Medium", fontSize: 15, color: textcolor)),
      ),
    ),
  );
}

CustomAppbar(
    {Widget? leading,
    String? centertext,
    bool? center,
    Color? cColor,
    IconData? actionicon,
    Function()? onclick,
    double? redi}) {
  return AppBar(
    elevation: 0,
    backgroundColor: WhiteColor,
    centerTitle: center,
    title: Text(centertext!,
        style: TextStyle(
            fontSize: 18, color: BlackColor, fontFamily: "Gilroy Bold")),
    leading: leading ??
        Transform.translate(
            offset: Offset(-6, 0), child: BackButton(color: BlackColor)),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: onclick,
          child: CircleAvatar(
            radius: redi,
            backgroundColor: cColor ?? greycolor.withOpacity(0.4),
            child: Icon(actionicon, color: BlackColor),
          ),
        ),
      )
    ],
  );
}

appTextfield(
    {TextEditingController? controller,
    String? text,
    suffix,
    Color? labelcolor,
    feildcolor,
    double? Width,
    bool? readOnly,
    TextInputType? keyboardType,
    Height}) {
  return Container(
      height: Height,
      width: Width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: WhiteColor),
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: text,
          isDense: true,
          labelStyle: TextStyle(
              color: greycolor, fontFamily: "Gilroy Medium", fontSize: 14),
          suffixIcon: Padding(padding: const EdgeInsets.all(6), child: suffix),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Greycolor.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(15)),
        ),
      ));
}

Button(
    {String? buttontext,
    Function()? onclick,
    double? Width,
    Color? buttoncolor}) {
  return GestureDetector(
    onTap: onclick,
    child: Container(
      height: 50,
      width: Width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: buttoncolor),
      child: Center(
        child: Text(
          buttontext!,
          style: TextStyle(
              fontFamily: "Gilroy Bold", color: WhiteColor, fontSize: 16),
        ),
      ),
    ),
  );
}

List Addtime = [
  {"id": "1", "text": "08:00 AM"},
  {"id": "2", "text": "08:30 AM"},
  {"id": "3", "text": "09:00 AM"},
  {"id": "4", "text": "09:30 AM"},
  {"id": "5", "text": "10:00 AM"},
  {"id": "6", "text": "10:30 AM"},
  {"id": "7", "text": "11:00 AM"},
  {"id": "8", "text": "11:30 AM"},
  {"id": "9", "text": "12:30 PM"},
  {"id": "10", "text": "01:00 PM"},
  {"id": "11", "text": "01:30 PM"},
  {"id": "12", "text": "02:00 PM"},
  {"id": "13", "text": "02:30 PM"},
  {"id": "14", "text": "03:00 PM"},
  {"id": "15", "text": "03:30 PM"},
  {"id": "16", "text": "04:0 PM"},
  {"id": "17", "text": "04:30 PM"},
  {"id": "18", "text": "05:00 PM"},
  {"id": "19", "text": "05:30 PM"},
  {"id": "20", "text": "06:00 PM"},
  {"id": "21", "text": "06:30 PM"},
  {"id": "22", "text": "07:00 PM"},
  {"id": "23", "text": "07:30 PM"},
  {"id": "24 ", "text": "08:00 PM"},
];

List deshbord = [
  {"text": "10", "subtext": "Add Services", "status": "1"},
  {"text": "07", "subtext": "Add Timeslot & Date", "status": "2"},
  {"text": "10", "subtext": "Sub Category", "status": "3"},
  {"text": "100", "subtext": "Total Earning(\$)", "status": "4"},
  {"text": "3.2", "subtext": "Review", "status": "5"},
  {"text": "100", "subtext": "Payout(\$)", "status": "6"},
  {"text": "10", "subtext": "Coupons", "status": "7"},
  {"text": "10", "subtext": "Service expert", "status": "8"},
  {"text": "5", "subtext": "Cover Images", "status": "9"},
  {"text": "6", "subtext": "Booking service", "status": "10"}
];
