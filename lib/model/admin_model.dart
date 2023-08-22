import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String uid;
  final String email;
  final bool isActive;
  final String role;
  final DateTime createdAt;

  AdminModel({
    required this.uid,
    required this.email,
    required this.createdAt,
  })  : isActive = true,
        role = '';

  AdminModel.fromMap(String uid, Map<String, dynamic> map)
      : uid = uid,
        email = map['email'] ?? '',
        isActive = map['isActive'] ?? false,
        role = map['role'] ?? '',
        createdAt = map['createdAt'] == null
            ? DateTime.now()
            : (map['createdAt'] as Timestamp).toDate();

  Map<String, dynamic> toMap(String password) {
    return {
      'email': email,
      'password': password,
    };
  }
}
