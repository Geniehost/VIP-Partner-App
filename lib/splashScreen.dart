// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously, prefer_const_constructors, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Utils/Colors.dart';

import 'Api/Config.dart';
import 'BottomBar.dart';
import 'IntroScreen/Intro_Screen.dart';
import 'Utils/AppWidget.dart';
import 'login&signup/Login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => getData.read("FirstUser") != true
            ? Get.to(() => LoginScreen())
            : getData.read("Remember") != true
                ? Get.to(() => const LoginScreen())
                : Get.to(() => const homepage(), duration: Duration.zero));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff007E5D),
      body: Column(children: [
        SizedBox(height: Get.height * 0.36),
        Center(child: Image.asset('assets/AppIcon.png', scale: 14)),
        SizedBox(height: 14),
        // Text("VIP Partner",
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 30,
        //         color: Darkblue,
        //         letterSpacing: 0.5))
      ]),
    );
  }
}
