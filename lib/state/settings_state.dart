import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../model/offer_model.dart';
import '../repo/offer_repo.dart';
import '../repo/settings_repo.dart';

class SettingsState extends ChangeNotifier {
  String _whatsappLink = '';
  String get whatsappLink => _whatsappLink;
  set whatsappLink(String link) {
    _whatsappLink = link;
    notifyListeners();
  }

  String _telegramLink = '';
  String get telegramLink => _telegramLink;
  set telegramLink(String link) {
    _telegramLink = link;
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
      final (String, String) links = await SettingsRepo.instance.getLink();
      whatsappLink = links.$1;
      telegramLink = links.$2;
      // pricingLink = '';

      this.offers = await OfferRepo.instance.getOffers();
    } catch (e) {
      log(e.toString());
    }
    isLoading = false;
  }
}
