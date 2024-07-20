// ignore_for_file: file_names, avoid_print, depend_on_referenced_packages, dead_code, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:service_provider/Api/ApiWrapper.dart';
import 'package:service_provider/Api/Config.dart';
import 'package:service_provider/AppModel/Dashbord/HomeData.dart';
import 'package:http/http.dart' as http;
import 'package:service_provider/AppModel/pauoutListModel.dart';
import 'package:service_provider/Utils/AppWidget.dart';

var vendorID;

class HomeGetData extends GetxController {
  HomeData? homeData;
  List serviceList = [];
  List<String> items = [];
  List pickupiteam = [];
  List<String> subitem = [];
  List pickupsubitem = [];
  List<String> catWiseGet = [];
  List catWiseGetID = [];

  homeDataGet() {
    vendorID = getData.read("UserLogin")["id"] ?? "";
    var data = {"vendor_id": vendorID};

    // var asdd
    ApiWrapper.dataPost(Config.homeData, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          log(val.toString(), name: "HomePage Api Call");

          homeData = HomeData.fromJson(val);
          serviceList = val["Servicelist"];
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  Future getServiceApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.serviceList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        update();
        return response["Servicelist"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
      print("Exeption----- $e");
    }
  }

  Future getSubCatApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.subList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        subitem.clear();
        pickupsubitem = response["Subcatlist"];
        response["Subcatlist"].forEach((e) {
          subitem.add("${e["sub_title"]}");
        });
        update();
        return response["Subcatlist"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future getCoverImageApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.coverList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        return response["Coverlist"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  getCatListApi() {
    var data = {"vendor_id": vendorID};
    ApiWrapper.dataPost(Config.catList, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          items.clear();
          pickupiteam = val["Catlist"];
          for (var i = 0; i < val["Catlist"].length; i++) {
            items.add(val["Catlist"][i]["cat_name"]);
          }
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  getCatWiseListApi(catid) {
    var data = {"vendor_id": vendorID, "cat_id": catid};
    ApiWrapper.dataPost(Config.catWiseSubList, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          catWiseGet.clear();
          update();
          catWiseGetID = val["Subcatlist"];
          for (var i = 0; i < val["Subcatlist"].length; i++) {
            catWiseGet.add(val["Subcatlist"][i]["sub_title"]);
          }
          update();
        } else {
          // ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }

  Future getCouponListApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.couponList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        return response["Couponlist"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future getDeliveryListApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.partnerList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        return response["Partnerlist"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //! Order List get
  Future getOrderListApi(type) async {
    var data = {"vendor_id": vendorID, "type": type};
    log(data.toString(), name: "Api Call :::: ");
    try {
      var url = Uri.parse(Config.baseurl + Config.orderHistory);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        return response["OrderHistory"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  //! Order List get
  PayoutList? paylist;
  Future getpayoutList() async {
    var data = {"vendor_id": vendorID};
    log(data.toString(), name: "Api Call :::: ");
    try {
      var url = Uri.parse(Config.baseurl + Config.payoutList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        paylist = PayoutList.fromJson(response);
        return response["Payoutlist"];
        update();
      } else {
        return [];
      }
    } catch (e) {
      return e;
    }
  }

  Future timeSloatApi() async {
    var data = {"vendor_id": vendorID};
    try {
      var url = Uri.parse(Config.baseurl + Config.timeSloatList);
      var request = await http.post(url,
          headers: ApiWrapper.headers, body: jsonEncode(data));
      var response = jsonDecode(request.body);
      if (response["ResponseCode"] == "200") {
        print(response["Timeslotlist"]);
        return response["Timeslotlist"];
      } else {
        return [];
      }
    } catch (e) {
      return e;
      print("Exeption----- $e");
    }
  }

  withdrawApi(amt, type) {
    var data = {"vendor_id": vendorID, "amt": amt, "r_type": type};
    ApiWrapper.dataPost(Config.requestwithdraw, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          homeDataGet();
          Get.back();
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
          update();
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}
