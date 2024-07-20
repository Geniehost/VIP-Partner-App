// ignore_for_file: camel_case_types, use_key_in_widget_constructors, annotate_overrides, prefer_const_literals_to_create_immutables, file_names, avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/String.dart';
import 'package:service_provider/login&signup/Login_screen.dart';

// class onbording extends StatefulWidget {
//   const onbording({Key? key}) : super(key: key);

//   @override
//   State<onbording> createState() => _onbordingState();
// }

// class _onbordingState extends State<onbording> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgcolor,
//       body: const Center(
//           // child: Image.asset("assets/images/applogo.png",
//           // height: 170, width: 200)
//           ),
//     );
//   }
// }

class BoardingPage extends StatefulWidget {
  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingPage> {
  void initState() {
    super.initState();

    _currentPage = 0;

    _slides = [
      Slide("assets/introscreen1.png", provider.bestser, provider.bestacc),
      Slide("assets/introscreen2.png", provider.bestservi, provider.getthe),
      Slide("assets/introscreen3.png", provider.expeart, provider.wehave),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  int _currentPage = 0;
  List<Slide> _slides = [];
  PageController _pageController = PageController();

  // the list which contain the build slides
  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
                height: Get.height / 1.8, //imagee size
                width: Get.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(alignment: Alignment.topRight, children: [
                    Image.asset(slide.image,
                        fit: BoxFit.cover, height: Get.height / 1.5),
                  ]),
                )),
          ),
          SizedBox(height: Get.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(slide.heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontFamily: "Gilroy Bold",
                    color: BlackColor)),
          ),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(slide.subtext,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: greycolor,
                    fontFamily: "Gilroy Medium") //subtext
                ),
          ),
        ]),
      ),
    );
  }

  // handling the on page changed
  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1)
        // ignore: curly_braces_in_flow_control_structures
        row.children.add(const SizedBox(width: 10));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 12 : 8,
      height: index == _currentPage ? 12 : 8,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == _currentPage ? Darkblue : greycolor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      body: Stack(
        children: <Widget>[
          Stack(children: [
            PageView(
                controller: _pageController,
                onPageChanged: _handlingOnPageChanged,
                physics: const BouncingScrollPhysics(),
                children: _buildSlides()),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 35,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black38),
                      child: Center(
                        child: Text("Skip",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Gilroy Bold",
                                color: WhiteColor)),
                      ),
                    )),
              ),
            )
          ]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: <Widget>[
                _buildPageIndicator(),
                SizedBox(height: Get.height * 0.025),
                _currentPage == 2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: BlackColor,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(provider.getstart,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: WhiteColor,
                                        fontFamily: "Gilroy Bold")),
                              )),
                        ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            _pageController.nextPage(
                                duration: const Duration(microseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: BlackColor,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  provider.continu,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: WhiteColor,
                                      fontFamily: "Gilroy Bold"),
                                ),
                              )),
                        )),
                SizedBox(height: Get.height * 0.012),
                const SizedBox(height: 20)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}
