class OfferModel {
  String id;
  String name;
  String price;
  String days;
  bool isActive;

  OfferModel({
    required this.id,
    required this.name,
    required this.price,
    required this.days,
    required this.isActive,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) {
    return OfferModel(
      id: data['id'].toString(),
      name: data['name'].toString(),
      price: data['price'].toString(),
      days: data['days'].toString(),
      isActive: data['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'days': days,
      'isActive': isActive,
    };
  }
}
