import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/users_model.dart';
import 'api_helper.dart';

class AuthRepo {
  static final instance = AuthRepo();

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

  Future<List<UserModel>> getUsers() async {
    return executeSafely(() async {
      final Request request = Request('/users', null);
      final response = await request.get(baseUrl);
      if (response.statusCode == 200) {
        final List<UserModel> userList = [];
        final List<dynamic> users = response.data;

        final searchesResponse =
            await Request('/users/searches', null).get(baseUrl);

        if (searchesResponse.statusCode == 200) {
          final List<dynamic> searches = searchesResponse.data;

          for (var user in users) {
            final List<UserSearch> userSearchList = [];

            for (var search in searches) {
              if (search['userId'] == user['id']) {
                userSearchList.add(UserSearch.fromMap(search));
              }
            }

            userList.add(UserModel.fromMap(user, userSearchList));
          }
        } else {
          throw Exception(searchesResponse.data);
        }

        return userList;
      } else {
        throw Exception(response.data['message']);
      }
    });
  }

  Future<void> addRecords(Uint8List file) async {
    return executeSafely(() async {
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          file,
          filename: 'records.xlsx',
        ),
      });

      final Request request = Request('/records', formData);
      final response = await request.post(baseUrl);
      if (response.statusCode == 200) {
        return;
      } else {
        log('error here : ${response.data}');
        throw Exception(response.data['message']);
      }
    });
  }

  Future<void> updateMembershipExpiryDate(
      String userId, DateTime expiryDate) async {
    return executeSafely(() async {
      final Request request = Request('/users/$userId/membership', {
        'membershipExpiry': expiryDate.toIso8601String(),
      });
      final response = await request.patch(baseUrl);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.data['message']);
      }
    });
  }
}
