// ignore_for_file: unused_field, file_names

import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/Utils/AppWidget.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:accordion/accordion.dart';

import '../Api/ApiWrapper.dart';
import '../Api/Config.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List faqList = [];
  final _loremIpsum =
      "Justo, fames odio enim, risus, ac tristique turpis. Ut molestie tempus, donec mauris nibh dolor urna eu. In dapibus eget eget in semper.";
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getfaqApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: BlackColor)),
        centerTitle: true,
        title: Text(
          "Faq's",
          style: TextStyle(
              color: BlackColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      // appBar: AppBar(
      //   titleSpacing: 0,
      //   elevation: 0,
      //   leading: InkWell(
      //       onTap: () {
      //         Get.back();
      //       },
      //       child: const Icon(Icons.arrow_back, color: Colors.black)),
      //   backgroundColor: CustomColors.skin,
      //   title: const Text("Faq's",
      //       style: TextStyle(
      //           fontSize: 18,
      //           fontWeight: FontWeight.w700,
      //           color: Colors.black)),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 250),
                    Center(child: isLoadingIndicator()),
                  ],
                )
              : Column(
                  children: [
                    Accordion(
                      disableScrolling: true,
                      flipRightIconIfOpen: true,
                      contentVerticalPadding: 0,
                      scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                      contentBorderColor: Colors.transparent,
                      maxOpenSections: 1,
                      headerBackgroundColorOpened: Colors.white,
                      headerBackgroundColor: Colors.white,
                      contentBackgroundColor: Colors.white,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      children: [
                        for (var i = 0; i < faqList.length; i++)
                          AccordionSection(
                              rightIcon:
                                  const Icon(Icons.add, color: Colors.black),
                              headerPadding: const EdgeInsets.all(15),
                              // flipRightIconIfOpen: true,
                              header: Text(faqList[i]["question"],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              content: Text(faqList[i]["answer"],
                                  style: _contentStyle),
                              contentHorizontalPadding: 20,
                              contentBackgroundColor: Colors.white,
                              contentBorderWidth: 1),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  getfaqApi() {
    isLoading = true;

    var body = {"vendor_id": vendorID};
    ApiWrapper.dataPost(Config.faq, body)!.then((faq) {
      if ((faq != null) && (faq.isNotEmpty)) {
        if ((faq['ResponseCode'] == "200") && (faq['Result'] == "true")) {
          setState(() {});
          isLoading = false;
          faqList = faq["FaqData"];
        }
      }
    });
  }
}
