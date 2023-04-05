class OfferModel {
  String uid;
  String price;
  String days;

  OfferModel({
    required this.uid,
    required this.price,
    required this.days,
  });

  factory OfferModel.fromMap(String uid, Map<String, dynamic> data) {
    return OfferModel(
      uid: uid,
      price: data['price'].toString(),
      days: data['days'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'days': days,
    };
  }
}
