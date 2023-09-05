import '../model/offer_model.dart';
import 'api_helper.dart';

class OfferRepo {
  static final OfferRepo instance = OfferRepo();

  Future<void> updateOffer(OfferModel offerModel) async {
    return executeSafely(() async {
      final Request request =
          Request('/offers/${offerModel.id}', offerModel.toMap());

      await request.patch(baseUrl);
    });
  }

  Future<List<OfferModel>> getOffers() {
    return executeSafely(() async {
      final Request request = Request('/offers', null);
      final response = await request.get(baseUrl);
      final List<OfferModel> offers = [];
      response.data.forEach((offer) {
        offers.add(OfferModel.fromMap(offer));
      });
      return offers;
    });
  }
}
