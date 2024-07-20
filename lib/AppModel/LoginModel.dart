// ignore_for_file: file_names

class LoginModel {
  Storedata? storedata;
  String? currency;
  String? responseCode;
  String? result;
  String? responseMsg;

  LoginModel(
      {this.storedata,
      this.currency,
      this.responseCode,
      this.result,
      this.responseMsg});

  LoginModel.fromJson(Map<String, dynamic> json) {
    storedata = json['storedata'] != null
        ? Storedata.fromJson(json['storedata'])
        : null;
    currency = json['currency'];
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (storedata != null) {
      data['storedata'] = storedata!.toJson();
    }
    data['currency'] = currency;
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    return data;
  }
}

//!  Storedata

class Storedata {
  String? id;
  String? title;
  String? rimg;
  String? status;
  String? rate;
  String? dtime;
  String? lcode;
  String? catid;
  String? fullAddress;
  String? pincode;
  String? landmark;
  String? lats;
  String? longs;
  String? storeCharge;
  String? dcharge;
  String? morder;
  String? commission;
  String? bankName;
  String? ifsc;
  String? receiptName;
  String? accNumber;
  String? paypalId;
  String? upiId;
  String? email;
  String? password;
  String? rstatus;
  String? mobile;
  String? sdesc;
  String? chargeType;
  String? ukm;
  String? uprice;
  String? aprice;
  String? zoneId;
  String? coverImg;

  Storedata(
      {this.id,
      this.title,
      this.rimg,
      this.status,
      this.rate,
      this.dtime,
      this.lcode,
      this.catid,
      this.fullAddress,
      this.pincode,
      this.landmark,
      this.lats,
      this.longs,
      this.storeCharge,
      this.dcharge,
      this.morder,
      this.commission,
      this.bankName,
      this.ifsc,
      this.receiptName,
      this.accNumber,
      this.paypalId,
      this.upiId,
      this.email,
      this.password,
      this.rstatus,
      this.mobile,
      this.sdesc,
      this.chargeType,
      this.ukm,
      this.uprice,
      this.aprice,
      this.zoneId,
      this.coverImg});

  Storedata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    rimg = json['rimg'];
    status = json['status'];
    rate = json['rate'];
    dtime = json['dtime'];
    lcode = json['lcode'];
    catid = json['catid'];
    fullAddress = json['full_address'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    lats = json['lats'];
    longs = json['longs'];
    storeCharge = json['store_charge'];
    dcharge = json['dcharge'];
    morder = json['morder'];
    commission = json['commission'];
    bankName = json['bank_name'];
    ifsc = json['ifsc'];
    receiptName = json['receipt_name'];
    accNumber = json['acc_number'];
    paypalId = json['paypal_id'];
    upiId = json['upi_id'];
    email = json['email'];
    password = json['password'];
    rstatus = json['rstatus'];
    mobile = json['mobile'];
    sdesc = json['sdesc'];
    chargeType = json['charge_type'];
    ukm = json['ukm'];
    uprice = json['uprice'];
    aprice = json['aprice'];
    zoneId = json['zone_id'];
    coverImg = json['cover_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['rimg'] = rimg;
    data['status'] = status;
    data['rate'] = rate;
    data['dtime'] = dtime;
    data['lcode'] = lcode;
    data['catid'] = catid;
    data['full_address'] = fullAddress;
    data['pincode'] = pincode;
    data['landmark'] = landmark;
    data['lats'] = lats;
    data['longs'] = longs;
    data['store_charge'] = storeCharge;
    data['dcharge'] = dcharge;
    data['morder'] = morder;
    data['commission'] = commission;
    data['bank_name'] = bankName;
    data['ifsc'] = ifsc;
    data['receipt_name'] = receiptName;
    data['acc_number'] = accNumber;
    data['paypal_id'] = paypalId;
    data['upi_id'] = upiId;
    data['email'] = email;
    data['password'] = password;
    data['rstatus'] = rstatus;
    data['mobile'] = mobile;
    data['sdesc'] = sdesc;
    data['charge_type'] = chargeType;
    data['ukm'] = ukm;
    data['uprice'] = uprice;
    data['aprice'] = aprice;
    data['zone_id'] = zoneId;
    data['cover_img'] = coverImg;
    return data;
  }
}
