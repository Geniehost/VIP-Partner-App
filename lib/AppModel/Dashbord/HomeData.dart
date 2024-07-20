// ignore_for_file: file_names

class HomeData {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<Servicelist>? servicelist;
  String? currency;
  ReportData? reportData;
  RecentOrder? recentOrder;

  HomeData(
      {this.responseCode,
      this.result,
      this.responseMsg,
      this.servicelist,
      this.currency,
      this.reportData,
      this.recentOrder});

  HomeData.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['Servicelist'] != null) {
      servicelist = <Servicelist>[];
      json['Servicelist'].forEach((v) {
        servicelist!.add(Servicelist.fromJson(v));
      });
    }
    currency = json['currency'];
    reportData = json['report_data'] != null
        ? ReportData.fromJson(json['report_data'])
        : null;
    recentOrder = json['recent_order'] != null
        ? RecentOrder.fromJson(json['recent_order'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (servicelist != null) {
      data['Servicelist'] = servicelist!.map((v) => v.toJson()).toList();
    }
    data['currency'] = currency;
    if (reportData != null) {
      data['report_data'] = reportData!.toJson();
    }
    if (recentOrder != null) {
      data['recent_order'] = recentOrder!.toJson();
    }
    return data;
  }
}

class Servicelist {
  String? serviceId;
  String? catId;
  String? subId;
  String? catName;
  String? subcatName;
  String? img;
  String? video;
  String? serviceType;
  String? title;
  String? takeTime;
  String? maxQuantity;
  String? price;
  String? discount;
  String? serviceDesc;
  String? status;
  String? isApprove;

  Servicelist(
      {this.serviceId,
      this.catId,
      this.subId,
      this.catName,
      this.subcatName,
      this.img,
      this.video,
      this.serviceType,
      this.title,
      this.takeTime,
      this.maxQuantity,
      this.price,
      this.discount,
      this.serviceDesc,
      this.status,
      this.isApprove});

  Servicelist.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    catId = json['cat_id'];
    subId = json['sub_id'];
    catName = json['cat_name'];
    subcatName = json['subcat_name'];
    img = json['img'];
    video = json['video'];
    serviceType = json['service_type'];
    title = json['title'];
    takeTime = json['take_time'];
    maxQuantity = json['max_quantity'];
    price = json['price'];
    discount = json['discount'];
    serviceDesc = json['service_desc'];
    status = json['status'];
    isApprove = json['is_approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['cat_id'] = catId;
    data['sub_id'] = subId;
    data['cat_name'] = catName;
    data['subcat_name'] = subcatName;
    data['img'] = img;
    data['video'] = video;
    data['service_type'] = serviceType;
    data['title'] = title;
    data['take_time'] = takeTime;
    data['max_quantity'] = maxQuantity;
    data['price'] = price;
    data['discount'] = discount;
    data['service_desc'] = serviceDesc;
    data['status'] = status;
    data['is_approve'] = isApprove;
    return data;
  }
}

class ReportData {
  dynamic totalService;
  dynamic totalTimeslot;
  dynamic totalSubcat;
  dynamic totalEarning;
  dynamic review;
  dynamic payout;
  dynamic withdrawLimit;
  dynamic totalCoupon;
  dynamic totalPartner;
  dynamic totalImage;
  dynamic totalOrders;

  ReportData(
      {this.totalService,
      this.totalTimeslot,
      this.totalSubcat,
      this.totalEarning,
      this.review,
      this.payout,
      this.withdrawLimit,
      this.totalCoupon,
      this.totalPartner,
      this.totalImage,
      this.totalOrders});

  ReportData.fromJson(Map<String, dynamic> json) {
    totalService = json['total_service'];
    totalTimeslot = json['total_timeslot'];
    totalSubcat = json['total_subcat'];
    totalEarning = json['total_earning'];
    review = json['review'];
    payout = json['payout'];
    withdrawLimit = json['withdraw_limit'];
    totalCoupon = json['total_coupon'];
    totalPartner = json['total_partner'];
    totalImage = json['total_image'];
    totalOrders = json['total_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_service'] = totalService;
    data['total_timeslot'] = totalTimeslot;
    data['total_subcat'] = totalSubcat;
    data['total_earning'] = totalEarning;
    data['review'] = review;
    data['payout'] = payout;
    data['withdraw_limit'] = withdrawLimit;
    data['total_coupon'] = totalCoupon;
    data['total_partner'] = totalPartner;
    data['total_image'] = totalImage;
    data['total_orders'] = totalOrders;
    return data;
  }
}

class RecentOrder {
  String? id;
  String? status;
  String? orderDate;
  String? total;
  String? customerAddress;
  String? storeAddress;
  String? distance;

  RecentOrder(
      {this.id,
      this.status,
      this.orderDate,
      this.total,
      this.customerAddress,
      this.storeAddress,
      this.distance});

  RecentOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    orderDate = json['order_date'];
    total = json['total'];
    customerAddress = json['customer_address'];
    storeAddress = json['store_address'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['order_date'] = orderDate;
    data['total'] = total;
    data['customer_address'] = customerAddress;
    data['store_address'] = storeAddress;
    data['distance'] = distance;
    return data;
  }
}
