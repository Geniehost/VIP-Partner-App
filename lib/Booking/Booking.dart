// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Booking/Completed.dart';
import 'package:service_provider/Booking/Current_order.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';
import 'package:service_provider/Utils/String.dart';

class Booking extends StatefulWidget {
  final String? type;
  const Booking({Key? key, this.type}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    List<Widget> tab = [
      const Currentorder(),
      const Completed(),
    ];
    return Scaffold(
        appBar: CustomAppbar(
            actionicon: null,
            leading: widget.type != "Hide" ? null : const SizedBox(),
            center: true,
            centertext: provider.book,
            onclick: () {},
            redi: 0),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  height: Get.height / 15,
                  width: Get.width / 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelStyle: const TextStyle(fontFamily: 'Gilroy_Bold'),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Darkblue,
                      controller: controller,
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      labelColor: Darkblue,
                      unselectedLabelColor: greycolor,
                      tabs: const [
                        Tab(
                          child: Text(provider.current,
                              style: TextStyle(
                                  fontFamily: 'Gilroy Medium', fontSize: 16)),
                        ),
                        Tab(
                          child: Text(
                            provider.complet,
                            style: TextStyle(
                                fontFamily: 'Gilroy Medium', fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: tab.map((tab) => tab).toList(),
              ),
            ),
          ],
        ));
  }
}
