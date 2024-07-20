// ignore_for_file: file_names, non_constant_identifier_names, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_brace_in_string_interps, unused_local_variable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppController/DashbordController.dart';
import 'package:service_provider/AppModel/pauoutListModel.dart';
import 'package:service_provider/Utils/Colors.dart';
import 'package:service_provider/Utils/Custom_widegt.dart';

import '../Utils/AppWidget.dart';

class Wallet extends StatefulWidget {
  final String? type;
  const Wallet({super.key, this.type});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final List<String> items = ['Mobile Money',];
  String? selectedValue;
  final y = Get.put(HomeGetData());
  final amount = TextEditingController();

  @override
  void initState() {
    y.homeDataGet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(y.paylist.i);
    return Scaffold(
      appBar: CustomAppbar(
          actionicon: null,
          leading: widget.type != "Hide" ? null : const SizedBox(),
          center: true,
          centertext: "Payout",
          onclick: () {},
          redi: 0),
      backgroundColor: bgcolor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GetBuilder<HomeGetData>(
              builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Balance(
                              onclick: () {},
                              text: "Available Balance",
                              text1: "${y.homeData?.currency}" +
                                  "${y.homeData?.reportData?.totalEarning.toString() ?? "0"}"),
                          Balance(
                            onclick: () {},
                            text: "Withdraw Limit",
                            text1: "${y.homeData?.currency}" +
                                "${y.homeData?.reportData?.withdrawLimit.toString() ?? "0"}",
                          )
                        ],
                      ),
                      SizedBox(height: Get.height * 0.03),
                      Center(
                        child: InkWell(
                          onTap: bottomsheet,
                          child: Container(
                            height: Get.height * 0.07,
                            width: Get.width * 0.50,
                            decoration: BoxDecoration(
                                border: Border.all(color: greycolor),
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset("assets/withdraw.png",
                                      height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9),
                                    child: Text("Withdraw",
                                        style: TextStyle(
                                            fontFamily: "Gilroy Bold",
                                            color: textcolor,
                                            fontSize: 20)),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text("Withdrawal History",
                          style: TextStyle(
                              fontFamily: "Gilroy Bold",
                              color: textcolor,
                              fontSize: 16)),
                      //! ---- Withdrawal History ------
                      Expanded(
                        child: SingleChildScrollView(
                            child: FutureBuilder(
                          future: y.getpayoutList(),
                          builder: (ctx, AsyncSnapshot snap) {
                            if (snap.hasData) {
                              var users = snap.data;
                              return users.length == 0
                                  ? Column(children: [
                                      SizedBox(height: Get.height * 0.18),
                                      Image(
                                          image: const AssetImage(
                                              "assets/emptyList1.png"),
                                          height: Get.height * 0.20),
                                      SizedBox(height: Get.height * 0.04),
                                      const Center(
                                          child: Text("Order  Not Found!!!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16))),
                                    ])
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: y.paylist?.payoutlist?.length,
                                      itemBuilder: (ctx, i) {
                                        return withdrawhistory(
                                            y.paylist?.payoutlist?[i], i);
                                      });
                            } else {
                              return Column(
                                children: [
                                  SizedBox(height: Get.height * 0.35),
                                  Center(child: isLoadingIndicator()),
                                ],
                              );
                            }
                          },
                        )),
                      )
                    ],
                  ))),
    );
  }

  Balance({String? text, text1, Function()? onclick}) {
    return InkWell(
      onTap: onclick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(color: greycolor),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(text!,
              style: TextStyle(
                  fontFamily: "Gilroy Bold", color: textcolor, fontSize: 14)),
          Text(text1,
              style: TextStyle(
                  fontFamily: "Gilroy Bold", color: textcolor, fontSize: 34)),
        ]),
      ),
    );
  }

  withdrawhistory(Payoutlist? payoutlist, i) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: WhiteColor),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(payoutlist!.status ?? "",
              style: TextStyle(
                  fontFamily: "Gilroy Medium",
                  color: greenColor,
                  fontSize: 16)),
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              height: 45,
              width: 45,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: yellowshadow),
              child: Image.network("${Config.imageURLPath}${payoutlist.proof}",
                  errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error_outline);
              }, height: 15)),
          SizedBox(width: Get.width * 0.025),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${y.homeData?.currency}${payoutlist.amt ?? "0"}",
                style: TextStyle(
                    fontFamily: "Gilroy Bold", color: textcolor, fontSize: 15)),
            Text(payoutlist.rType ?? "",
                style: TextStyle(
                    fontFamily: "Gilroy MEdium",
                    color: greycolor,
                    fontSize: 14)),
          ]),
        ]),
        SizedBox(height: Get.height * 0.01),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Date: ${payoutlist.rDate}",
              style: TextStyle(
                  fontFamily: "Gilroy Medium", color: greycolor, fontSize: 15)),
          SizedBox(
            height: Get.height * 0.04,
            child: Appbutton(
                Width: Get.width * 0.28,
                border: null,
                buttoncolor: BlackColor,
                buttontext: "Details",
                onclick: () {
                  detailwithdraw(
                      payoutlist.payoutId,
                      payoutlist.amt,
                      payoutlist.proof,
                      payoutlist.rType,
                      payoutlist.rDate,
                      payoutlist.status);
                },
                textcolor: WhiteColor),
          )
        ]),
      ]),
    );
  }

  bottomsheet() {
    amount.clear();
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Withdraw",
                        style: TextStyle(
                            fontFamily: "Gilroy Bold",
                            color: textcolor,
                            fontSize: 20)),
                    SizedBox(height: Get.height * 0.03),
                    appTextfield(
                        feildcolor: WhiteColor,
                        labelcolor: greycolor,
                        suffix: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                          buttonHeight: 40,
                          buttonWidth: double.infinity,
                          itemHeight: 40,
                          value: selectedValue,
                          hint: Text(items.first,
                              style: TextStyle(fontSize: 14, color: greycolor)),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(item,
                                          style: const TextStyle(fontSize: 14)),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {});
                            selectedValue = value;
                          },
                        )),
                        text: ""),
                    SizedBox(height: Get.height * 0.02),
                    appTextfield(
                        controller: amount,
                        feildcolor: WhiteColor,
                        labelcolor: greycolor,
                        keyboardType: TextInputType.number,
                        suffix: null,
                        text: "Amount"),
                    SizedBox(height: Get.height * 0.02),
                    Center(
                      child: Button(
                        Width: Get.width * 0.5,
                        buttoncolor: gradientColor,
                        buttontext: "Submit",
                        onclick: () {
                          dynamic widamt = double.parse("${amount.text}");
                          if (amount.text.isNotEmpty && widamt > 0) {
                            y.withdrawApi(amount.text, selectedValue);
                          } else {
                            ApiWrapper.showToastMessage("Please enter amount");
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

//! ----- Details BottomSheet ------
  detailwithdraw(id, amt, proof, method, date, status) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: bgcolor,
        isScrollControlled: true,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.02),
                BlanceDetails(
                    Counttext: "1", idtext: id, listtext: "Request ID :"),
                SizedBox(height: Get.height * 0.035),
                BlanceDetails(
                    Counttext: "2", idtext: amt, listtext: "Amount :"),
                SizedBox(height: Get.height * 0.030),
                BlanceDetails(
                    Counttext: "3",
                    idtext: method,
                    listtext: "Payment Method :"),
                SizedBox(height: Get.height * 0.035),
                BlanceDetails(
                    Counttext: "4", idtext: date, listtext: "Request Date :"),
                SizedBox(height: Get.height * 0.035),
                BlanceDetails(
                    Counttext: "5", idtext: status, listtext: "Status :"),
                SizedBox(height: Get.height * 0.035),
                BlanceDetails(
                    Counttext: "6", idtext: "", listtext: "Paynent Proof :"),
                SizedBox(height: Get.height * 0.020),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.12),
                  child: Container(
                      height: 170,
                      width: 170,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: yellowshadow),
                      child: Image.network("${Config.imageURLPath}${proof}",
                          errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error_outline);
                      }, height: 15)),
                ),
              ],
            ),
          );
        });
  }

  BlanceDetails({String? Counttext, listtext, idtext}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.black38,
          child: Text(Counttext!,
              style: TextStyle(
                  fontFamily: "Gilroy Medium",
                  color: WhiteColor,
                  fontSize: 15)),
        ),
        SizedBox(width: Get.width * 0.05),
        Row(
          children: [
            Text(
              listtext,
              style: TextStyle(
                  fontFamily: "Gilroy Medium", color: textcolor, fontSize: 16),
            ),
            SizedBox(width: Get.width * 0.015),
            Text(idtext,
                style: TextStyle(
                    fontFamily: "Gilroy Medium",
                    color: textcolor,
                    fontSize: 16))
          ],
        ),
      ],
    );
  }
}
