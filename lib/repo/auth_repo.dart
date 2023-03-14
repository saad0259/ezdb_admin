import 'package:firebase_auth/firebase_auth.dart';

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

  String _getErrorMessage(String code) {
    String errorMessage;
    switch (code) {
      case 'auth/email-already-exists':
        errorMessage = 'The email is already in use by another account.';
        break;

      case 'auth/id-token-expired':
        errorMessage = 'The user token has expired.';
        break;

      case 'auth/invalid-api-key':
        errorMessage = 'The API key is invalid.';
        break;

      case 'auth/invalid-credential':
        errorMessage = 'The credential is invalid.';
        break;

      case 'auth/invalid-email':
        errorMessage = 'The email address is badly formatted.';
        break;

      default:
        errorMessage = 'An unknown error occurred.';
    }
    return errorMessage;
  }
}
