import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../model/offer_model.dart';
import '../repo/offer_repo.dart';
import '../repo/settings_repo.dart';

class SettingsState extends ChangeNotifier {
  String _pricingLink = '';
  String get pricingLink => _pricingLink;
  set pricingLink(String link) {
    _pricingLink = link;
    notifyListeners();
  }

  List<OfferModel> _offers = [];
  List<OfferModel> get offers => _offers;
  set offers(List<OfferModel> offers) {
    _offers = offers;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  loadData() async {
    isLoading = true;
    try {
      pricingLink = await SettingsRepo.instance.getLink();
      // pricingLink = '';

      this.offers = await OfferRepo.instance.getOffers();
    } catch (e) {
      log(e.toString());
    }
    isLoading = false;
  }
}
