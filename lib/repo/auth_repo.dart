import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/enum/dashboard_filter_enum.dart';
import '../model/users_model.dart';

class AuthRepo {
  static final instance = AuthRepo();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserCredential> login(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final token = await user.getIdTokenResult();
      return token.claims!['role'] != null
          ? token.claims!['role'] == 'admin'
              ? true
              : false
          : false;
    } else {
      return false;
    }
  }

  // String _getErrorMessage(String code) {
  //   String errorMessage;
  //   switch (code) {
  //     case 'auth/email-already-exists':
  //       errorMessage = 'The email is already in use by another account.';
  //       break;

  //     case 'auth/id-token-expired':
  //       errorMessage = 'The user token has expired.';
  //       break;

  //     case 'auth/invalid-api-key':
  //       errorMessage = 'The API key is invalid.';
  //       break;

  //     case 'auth/invalid-credential':
  //       errorMessage = 'The credential is invalid.';
  //       break;

  //     case 'auth/invalid-email':
  //       errorMessage = 'The email address is badly formatted.';
  //       break;

  //     default:
  //       errorMessage = 'An unknown error occurred.';
  //   }
  //   return errorMessage;
  // }

  Future<List<UserModel>> getUsersByFilter(DashboardFilter filter) async {
    final List<UserModel> userList = [];
    try {
      final users = await _usersCollection
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: filter.startAt,
            isLessThanOrEqualTo: filter.endAt,
          )
          .orderBy('createdAt', descending: true)
          .get();

      for (var userDoc in users.docs) {
        //make a map of users and there ids to later use in mappping
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;

        final userSearchSnapshot =
            await userDoc.reference.collection('userSearch').get();

        final userSearchData = userSearchSnapshot.docs
            .map((e) => UserSearch.fromMap(e.data()))
            .where((element) => element.createdAt.isAfter(filter.startAt))
            .where((element) => element.createdAt.isBefore(filter.endAt))
            .toList();
        userSearchData.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        userList.add(UserModel.fromMap(userDoc.id, userData, userSearchData));
      }
    } catch (e) {
      print('------- getUsers() error: $e');
    }
    return userList;
  }

  Stream<List<UserModel>> watchUsers() {
    return _usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((users) async {
      final List<UserModel> userList = [];

      for (var userDoc in users.docs) {
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;

        final userSearchSnapshot =
            await userDoc.reference.collection('userSearch').get();

        final userSearchData = userSearchSnapshot.docs
            .map((e) => UserSearch.fromMap(e.data()))
            .toList();
        userSearchData.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        userList.add(UserModel.fromMap(userDoc.id, userData, userSearchData));
      }

      return userList;
    });
  }

  Future<void> updateMembershipExpiryDate(
      String userId, DateTime expiryDate) async {
    try {
      await _usersCollection.doc(userId).update({
        'memberShipExpiry': expiryDate,
      });
    } catch (e) {
      log('------- updateMembershipExpiryDate() error: $e');
      rethrow;
    }
  }

  Future<void> updateBlockStatus(String userId, bool isBlocked) async {
    try {
      await _usersCollection.doc(userId).update({'isBlocked': isBlocked});
    } catch (e) {
      log('------- updateBlockStatus() error: $e');
      rethrow;
    }
  }
}
