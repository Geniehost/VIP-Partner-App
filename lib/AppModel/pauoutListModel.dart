// ignore_for_file: file_names

class PayoutList {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<Payoutlist>? payoutlist;

  PayoutList(
      {this.responseCode, this.result, this.responseMsg, this.payoutlist});

  PayoutList.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['Payoutlist'] != null) {
      payoutlist = <Payoutlist>[];
      json['Payoutlist'].forEach((v) {
        payoutlist!.add(Payoutlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (payoutlist != null) {
      data['Payoutlist'] = payoutlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payoutlist {
  String? payoutId;
  String? amt;
  String? status;
  String? proof;
  String? rDate;
  String? rType;

  Payoutlist(
      {this.payoutId,
      this.amt,
      this.status,
      this.proof,
      this.rDate,
      this.rType});

  Payoutlist.fromJson(Map<String, dynamic> json) {
    payoutId = json['payout_id'];
    amt = json['amt'];
    status = json['status'];
    proof = json['proof'];
    rDate = json['r_date'];
    rType = json['r_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payout_id'] = payoutId;
    data['amt'] = amt;
    data['status'] = status;
    data['proof'] = proof;
    data['r_date'] = rDate;
    data['r_type'] = rType;
    return data;
  }
}
