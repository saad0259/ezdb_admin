import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/offer_model.dart';

class OfferRepo {
  static final OfferRepo instance = OfferRepo();
  final CollectionReference _offerCollection =
      FirebaseFirestore.instance.collection('offers');

  Future<void> updateOffer(String docId, String price, String days) async {
    try {
      await _offerCollection.doc(docId).update({
        'price': price,
        'days': days,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<OfferModel>> watchOffers() {
    return _offerCollection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OfferModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
