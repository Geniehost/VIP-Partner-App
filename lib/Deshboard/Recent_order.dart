// ignore_for_file: file_names
// // ignore_for_file: prefer_const_constructors, file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:service_provider/Utils/Colors.dart';
// import 'package:service_provider/Utils/Custom_widegt.dart';

// class Recentorder extends StatefulWidget {
//   const Recentorder({super.key});

//   @override
//   State<Recentorder> createState() => _RecentorderState();
// }

// class _RecentorderState extends State<Recentorder> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgcolor,
//       appBar: CustomAppbar(
//         actionicon: null,
//         center: true,
//         redi: 0,
//         centertext: "Recent Order",
//         onclick: () {},
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         child: ListView.builder(
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: 5,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               decoration: BoxDecoration(
//                   border: Border.all(color: bgcolor),
//                   borderRadius: BorderRadius.circular(12),
//                   color: WhiteColor),
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               height: 55,
//                               width: 55,
//                               child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.asset("assets/repair.jpg",
//                                       fit: BoxFit.fitHeight)),
//                             ),
//                             SizedBox(width: Get.width * 0.03),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Ac Service",
//                                     style: TextStyle(
//                                         fontFamily: "Gilroy Bold",
//                                         fontSize: 15,
//                                         color: BlackColor)),
//                                 SizedBox(height: Get.width * 0.01),
//                                 Text("Daily repair",
//                                     style: TextStyle(
//                                         fontFamily: "Gilroy Medium",
//                                         fontSize: 14,
//                                         color: greycolor)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("#123456",
//                                 style: TextStyle(
//                                     fontFamily: "Gilroy Medium",
//                                     fontSize: 15,
//                                     color: greentext)),
//                             SizedBox(height: Get.height * 0.014),
//                             Text("\$10.00",
//                                 style: TextStyle(
//                                     fontFamily: "Gilroy Bold",
//                                     fontSize: 15,
//                                     color: textcolor)),
//                           ],
//                         )
//                       ]),
//                   SizedBox(height: Get.height * 0.015),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.04,
//                         child: Appbutton(
//                           Width: Get.width * 0.43,
//                           buttontext: "Accept",
//                           buttoncolor: BlackColor,
//                           border: null,
//                           textcolor: WhiteColor,
//                           onclick: () {},
//                         ),
//                       ),
//                       SizedBox(
//                           height: Get.height * 0.04,
//                           child: Appbutton(
//                             Width: Get.width * 0.43,
//                             buttontext: "Reject",
//                             buttoncolor: WhiteColor,
//                             textcolor: RedColor,
//                             border: Border.all(color: RedColor),
//                             onclick: () {},
//                           ))
//                     ],
//                   )
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
