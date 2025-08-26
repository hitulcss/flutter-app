
class StoreFaqs {
  String? q;
  String? a;

  StoreFaqs({this.q, this.a});

  StoreFaqs.fromJson(Map<String, dynamic> json) {
    q = json['q'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['q'] = q;
    data['a'] = a;
    return data;
  }
}