// ignore_for_file: file_names

class SubcategoryList {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<Subcatlist>? subcatlist;

  SubcategoryList(
      {this.responseCode, this.result, this.responseMsg, this.subcatlist});

  SubcategoryList.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['Subcatlist'] != null) {
      subcatlist = <Subcatlist>[];
      json['Subcatlist'].forEach((v) {
        subcatlist!.add(Subcatlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (subcatlist != null) {
      data['Subcatlist'] = subcatlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcatlist {
  String? subId;
  String? catId;
  String? catName;
  String? subTitle;
  String? subImg;
  String? status;
  String? isApprove;

  Subcatlist(
      {this.subId,
      this.catId,
      this.catName,
      this.subTitle,
      this.subImg,
      this.status,
      this.isApprove});

  Subcatlist.fromJson(Map<String, dynamic> json) {
    subId = json['sub_id'];
    catId = json['cat_id'];
    catName = json['cat_name'];
    subTitle = json['sub_title'];
    subImg = json['sub_img'];
    status = json['status'];
    isApprove = json['is_approve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_id'] = subId;
    data['cat_id'] = catId;
    data['cat_name'] = catName;
    data['sub_title'] = subTitle;
    data['sub_img'] = subImg;
    data['status'] = status;
    data['is_approve'] = isApprove;
    return data;
  }
}
