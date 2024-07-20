// ignore_for_file: unused_import, camel_case_types, unused_field, library_private_types_in_public_api, file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Booking/Booking.dart';
import 'package:service_provider/Deshboard/Deshboard.dart';
import 'package:service_provider/Profile/Profile.dart';
import 'package:service_provider/WalletPage/Wallet.dart';
import 'package:service_provider/Service/servicesListPage.dart';

int selectedIndex = 0;

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> with TickerProviderStateMixin {
  late int _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  List<Widget> myChilders = const [
    Deshboard(),
    services(type: "Hide"),
    Booking(type: "Hide"),
    Wallet(type: "Hide"),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: BlackColor,
          backgroundColor: WhiteColor,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Gilroy Bold',
              fontWeight: FontWeight.bold,
              fontSize: 12),
          fixedColor: BlackColor,
          unselectedLabelStyle: const TextStyle(fontFamily: 'Gilroy Medium'),
          currentIndex: selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/dashboard-.png",
                    color: selectedIndex == 0 ? Darkblue : greycolor,
                    height: Get.height / 40),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Image.asset("assets/Document.png",
                    color: selectedIndex == 1 ? Darkblue : greycolor,
                    height: Get.height / 36),
                label: 'Services'),
            BottomNavigationBarItem(
                icon: Image.asset("assets/calendar.png",
                    color: selectedIndex == 2 ? Darkblue : greycolor,
                    height: Get.height / 40),
                label: 'Booking'),
            BottomNavigationBarItem(
              icon: Image.asset("assets/wallet.png",
                  color: selectedIndex == 3 ? Darkblue : greycolor,
                  height: Get.height / 40),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/Profile.png",
                  color: selectedIndex == 4 ? Darkblue : greycolor,
                  height: Get.height / 40),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {});
            selectedIndex = index;
          },
        ),
        body: myChilders[selectedIndex],
      ),
    );
  }
}
