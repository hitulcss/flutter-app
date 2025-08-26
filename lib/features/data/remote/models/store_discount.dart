class StoreDiscount {
  int? discount;
  String? image;

  StoreDiscount({this.discount, this.image});

  StoreDiscount.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discount'] = discount;
    data['image'] = image;
    return data;
  }
}