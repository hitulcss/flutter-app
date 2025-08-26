class GetPinCode {
  int? pincode;
  String? stateCode;
  String? district;
  String? prepaid;
  String? reversePickup;
  String? rEPL;
  String? cOD;
  String? cash;

  GetPinCode(
      {this.pincode,
      this.stateCode,
      this.district,
      this.prepaid,
      this.reversePickup,
      this.rEPL,
      this.cOD,
      this.cash});

  GetPinCode.fromJson(Map<String, dynamic> json) {
    pincode = json['Pincode'];
    stateCode = json['State Code'];
    district = json['District'];
    prepaid = json['Prepaid'];
    reversePickup = json['Reverse Pickup'];
    rEPL = json['REPL'];
    cOD = json['COD'];
    cash = json['Cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Pincode'] = pincode;
    data['State Code'] = stateCode;
    data['District'] = district;
    data['Prepaid'] = prepaid;
    data['Reverse Pickup'] = reversePickup;
    data['REPL'] = rEPL;
    data['COD'] = cOD;
    data['Cash'] = cash;
    return data;
  }
}
