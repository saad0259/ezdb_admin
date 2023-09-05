import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SettingsRepo {
  static final SettingsRepo instance = SettingsRepo();
  final CollectionReference _settingsCollection =
      FirebaseFirestore.instance.collection('settings');

  Future<void> updateLink(String whatsappLink, String telegramLink) async {
    try {
      await _settingsCollection.doc('pricingLink').update({
        'whatsappLink': whatsappLink,
        'telegramLink': telegramLink,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<(String, String)> getLink() async {
    try {
      final doc = await _settingsCollection.doc('pricingLink').get();
      debugPrint('SettingsRepo.getLink: doc.data() = ${doc.data()}');
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['whatsappLink'].toString(), data['telegramLink'].toString());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
