class GetStoreAddress {
  bool? status;
  List<GetStoreAddressData>? data;
  String? msg;

  GetStoreAddress({this.status, this.data, this.msg});

  GetStoreAddress.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <GetStoreAddressData>[];
      json['data'].forEach((v) {
        data!.add(GetStoreAddressData.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    return data;
  }
}

class GetStoreAddressData {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? streetAddress;
  String? city;
  String? state;
  String? country;
  String? pinCode;

  GetStoreAddressData(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.streetAddress,
      this.city,
      this.state,
      this.country,
      this.pinCode});

  GetStoreAddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    streetAddress = json['streetAddress'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['streetAddress'] = streetAddress;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pinCode'] = pinCode;
    return data;
  }
}
