// ignore_for_file: file_names, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/AppModel/LoginModel.dart';
import 'package:service_provider/BottomBar.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Utils/String.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isSelected = false;

  bool isChecked = false;
  bool _obscureText = true;
  var data;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
          actionicon: null,
          center: false,
          centertext: "",
          onclick: () {},
          redi: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.lets,
              style: TextStyle(
                  fontSize: 22, fontFamily: "Gilroy Bold", color: BlackColor),
            ),
            SizedBox(height: Get.height * 0.01),
            SizedBox(
              width: Get.width * 0.60,
              child: Text(provider.welcome,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Gilroy Medium",
                      color: greycolor)),
            ),
            SizedBox(height: Get.height * 0.05),
            appTextfield(
                controller: email,
                feildcolor: bgcolor,
                labelcolor: greycolor,
                text: provider.email),
            SizedBox(height: Get.height * 0.04),
            passwordtextfield(),
            SizedBox(height: 8),
            Row(
              children: [
                Theme(
                    data: ThemeData(unselectedWidgetColor: BlackColor),
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: isChecked,
                      activeColor: BlackColor,
                      onChanged: (value) {
                        setState(() {
                          save("Remember", value);
                          isChecked = value!;
                        });
                      },
                    )),
                Text(provider.remember,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Gilroy Medium",
                        color: BlackColor)),
              ],
            ),
            SizedBox(height: Get.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Checkbox(
                  splashRadius: 30,
                  value: isSelected,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  activeColor: Colors.blueAccent,
                  onChanged: (value) {
                    setState(() {
                      isSelected = value!;
                    });
                  }),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("By accepting, you agree to our".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 13)),
                const SizedBox(height: 5),
                Text("Term and Conditions".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.blueAccent)),
              ]),
            ]),
            SizedBox(height: 12),
            InkWell(
              onTap: () {
                if ((RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email.text))) {
                  if (email.text.isNotEmpty && password.text.isNotEmpty) {
                    if (isSelected == true) {
                      userLogin(email.text.trim(), password.text);
                    } else {
                      ApiWrapper.showToastMessage(
                          "Please Accept Term conditions");
                    }
                  } else {
                    ApiWrapper.showToastMessage("Please fill required field!");
                  }
                } else {
                  ApiWrapper.showToastMessage(
                      'Please enter valid email address');
                }
              },
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: BlackColor),
                  child: Center(
                      child: Text(provider.login,
                          style: TextStyle(
                              fontSize: 16,
                              color: WhiteColor,
                              fontFamily: "Gilroy Bold")))),
            ),
            SizedBox(height: Get.height * 0.05),
          ],
        ),
      ),
    );
  }

  Widget passwordtextfield() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: password,
        obscureText: _obscureText,
        style: TextStyle(fontSize: 16, color: BlackColor),
        decoration: InputDecoration(
          labelText: "password",
          labelStyle: TextStyle(
              color: greycolor, fontFamily: "Gilroy Medium", fontSize: 14),
          suffixIcon: InkWell(
              onTap: () {
                _toggle();
              },
              child: !_obscureText
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off, color: greycolor)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Greycolor.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  //! user Login Api
  LoginModel? userData;

  userLogin(email, password) {
    data = {"email": email, "password": password};
    log(data.toString(), name: "Login Api : ");
    ApiWrapper.dataPost(Config.loginuser, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          save("FirstUser", true);
          userData = LoginModel.fromJson(val);
          log(userData.toString(), name: "Login Api : ");
          save("UserLogin", val["storedata"]);
          Get.to(() => const homepage(), duration: Duration.zero);
          Get.put(HomeGetData()).homeDataGet();

          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
