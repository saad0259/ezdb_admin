class OfferModel {
  String id;
  String name;
  String price;
  String days;

  OfferModel({
    required this.id,
    required this.name,
    required this.price,
    required this.days,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) {
    return OfferModel(
      id: data['id'].toString(),
      name: data['name'].toString(),
      price: data['price'].toString(),
      days: data['days'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'days': days,
    };
  }
}
