import 'dart:developer';

import '../model/offer_model.dart';
import 'api_helper.dart';

class OfferRepo {
  static final OfferRepo instance = OfferRepo();

  Future<void> updateOffer(OfferModel offerModel) async {
    return executeSafely(() async {
      final Request request =
          Request('/offers/${offerModel.id}', offerModel.toMap());

      final response = await request.patch(baseUrl);
      log(response.data.toString());
    });
  }

  Future<List<OfferModel>> getOffers() {
    return executeSafely(() async {
      final Request request = Request('/offers', null);
      final response = await request.get(baseUrl);
      log(response.data.toString());
      final List<OfferModel> offers = [];
      response.data.forEach((offer) {
        offers.add(OfferModel.fromMap(offer));
      });
      return offers;
    });
  }
}
